# EF Migration Transformation Agent — Report

**Project:** Bookstore.Data  
**Source Provider:** Microsoft SQL Server (MSSQL)  
**Target Provider:** PostgreSQL (Npgsql)  
**EF Version:** EF Core 8.0.x  
**Date:** Migration agent execution

---

## 1. Migration File Scan Result

**No EF migration files were found** in the Bookstore.Data project directory.

Searched path: `app/Bookstore.Data/` (all subdirectories)  
Expected artifacts: `Migrations/` folder, `*_InitialCreate.cs`, `ApplicationDbContextModelSnapshot.cs`  
Result: **None found — the `Migrations/` folder does not exist.**

---

## 2. Current Schema Creation Strategy

The application uses **`Database.EnsureCreatedAsync()`** in `MiddlewareSetup.cs`:

```csharp
// Bookstore.Web/Startup/MiddlewareSetup.cs
using (var scope = app.Services.CreateAsyncScope())
{
    await scope.ServiceProvider.GetService<ApplicationDbContext>()!
        .Database.EnsureCreatedAsync();
}
```

This means EF Core creates the database schema at application startup by inferring it
directly from the entity model and `OnModelCreating` configuration — **no migration
files are involved at all**.

---

## 3. PostgreSQL Provider Status — Already Migrated

Inspection of the project files reveals the application has **already been converted
to the Npgsql provider**. No SQL Server provider references remain:

### 3.1 Bookstore.Data.csproj
```xml
<!-- SQL Server package is ABSENT -->
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="8.0.10" />
<PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.0.10" />
```

### 3.2 ApplicationDbContext.cs
```csharp
using Microsoft.EntityFrameworkCore;
using Npgsql.EntityFrameworkCore.PostgreSQL; // Npgsql using present

static ApplicationDbContext()
{
    // Legacy timestamp behaviour explicitly set for Npgsql
    AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
}
```

### 3.3 ServicesSetup.cs
```csharp
// PostgreSQL provider registered — no UseSqlServer anywhere
builder.Services.AddDbContext<ApplicationDbContext>(
    option => option.UseNpgsql(connString));
```

### 3.4 Bookstore.Web.csproj
```xml
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="8.0.10" />
<!-- No Microsoft.EntityFrameworkCore.SqlServer reference -->
```

---

## 4. Schema Mapping Verification

All entity classes and `OnModelCreating` in `ApplicationDbContext` have been verified.
Every table and column is already mapped to **lowercase PostgreSQL-compatible names**
under the `bobsbookstore_dbo` schema.

| Entity Class       | Table Name (as mapped)              | Schema              |
|--------------------|-------------------------------------|---------------------|
| `Address`          | `address`                           | `bobsbookstore_dbo` |
| `Book`             | `book`                              | `bobsbookstore_dbo` |
| `Customer`         | `customer`                          | `bobsbookstore_dbo` |
| `Order`            | `Order` *(see note below)*          | `bobsbookstore_dbo` |
| `ShoppingCart`     | `shoppingcart`                      | `bobsbookstore_dbo` |
| `ShoppingCartItem` | `shoppingcartitem`                  | `bobsbookstore_dbo` |
| `OrderItem`        | `orderitem`                         | `bobsbookstore_dbo` |
| `Offer`            | `offer`                             | `bobsbookstore_dbo` |
| `Author`           | `author`                            | `bobsbookstore_dbo` |
| `Product`          | `product`                           | `bobsbookstore_dbo` |
| `ReferenceDataItem`| `referencedata`                     | `bobsbookstore_dbo` |

> **⚠️ ADVISORY — `Order` table name casing:**  
> The `Order` entity is mapped as `entity.ToTable("Order", "bobsbookstore_dbo")` in  
> `ApplicationDbContext.cs` AND as `[Table("Order", Schema = "bobsbookstore_dbo")]` on  
> the entity class. The table name retains a capital `O` (`"Order"`).  
> PostgreSQL identifiers are case-folded to lowercase by default, so this will work
> correctly as long as no quoted identifier (`"Order"`) is used in raw SQL elsewhere.
> For maximum consistency with all other tables (which are lowercase), the DbContext
> agent should normalise this to `"order"` (lowercase). **This is outside the scope
> of this migration agent but is flagged here for the DbContext/entity agent.**

All column names in both entity `[Column(...)]` attributes and `OnModelCreating`
are already lowercase and PostgreSQL-compatible.

---

## 5. EnsureCreatedAsync() Compatibility with Npgsql

With `EnsureCreatedAsync()` and the Npgsql provider, EF Core will:

1. Connect to the configured PostgreSQL database.
2. Check whether any tables in the model already exist.
3. If not, generate DDL from the entity model and execute it.
4. Seed data via `modelBuilder.Entity<T>().HasData(...)` defined in `SeedData.cs`.

**This strategy is fully compatible with the Npgsql provider** provided the following
conditions (all already met) hold true:

| Condition | Status |
|---|---|
| `UseNpgsql()` registered instead of `UseSqlServer()` | ✅ Already done |
| No SQL Server-specific type annotations remain in entities | ✅ Entities use no `[Column(TypeName="nvarchar...")]` etc. |
| No `SqlServer:Identity` annotations in `OnModelCreating` | ✅ None present — EF Core uses value-generation conventions |
| `Npgsql.EnableLegacyTimestampBehavior` set for DateTime handling | ✅ Set in static constructor |
| Schema (`bobsbookstore_dbo`) exists in target PostgreSQL instance | ⚠️ Must be created before first run (see Section 6) |
| Seed data uses provider-agnostic C# types | ✅ All seed data uses `int`, `string`, `decimal` — no SQL types |

---

## 6. Required Pre-Startup Action — Schema Creation

`EnsureCreatedAsync()` creates **tables** but does **not** create the PostgreSQL
**schema** (`bobsbookstore_dbo`) if it does not already exist. Attempting to create
tables in a non-existent schema will throw a PostgreSQL error:

```
ERROR: schema "bobsbookstore_dbo" does not exist
```

**Resolution options (choose one):**

### Option A — Create schema in database initialisation SQL (Recommended)
Run this once as part of deployment / infrastructure setup:
```sql
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;
```

### Option B — Add schema creation to MiddlewareSetup.cs
Execute raw SQL before `EnsureCreatedAsync()`:
```csharp
// Bookstore.Web/Startup/MiddlewareSetup.cs
using (var scope = app.Services.CreateAsyncScope())
{
    var db = scope.ServiceProvider.GetService<ApplicationDbContext>()!;
    // Ensure the schema exists before EnsureCreatedAsync creates tables
    await db.Database.ExecuteSqlRawAsync(
        "CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;");
    await db.Database.EnsureCreatedAsync();
}
```

### Option C — Use PostgreSQL superuser role at RDS provisioning
Ensure the CDK / CloudFormation stack that provisions the RDS instance also runs
the `CREATE SCHEMA` statement as part of its initialisation scripts.

---

## 7. Guidance: Adopting EF Migrations in the Future

If the team decides to replace `EnsureCreatedAsync()` with proper EF Core migrations
(recommended for production environments to enable incremental schema evolution):

### Step 1 — Remove `EnsureCreatedAsync()` from `MiddlewareSetup.cs`
Replace with migration application:
```csharp
using (var scope = app.Services.CreateAsyncScope())
{
    var db = scope.ServiceProvider.GetService<ApplicationDbContext>()!;
    await db.Database.MigrateAsync(); // applies pending migrations
}
```

### Step 2 — Generate the initial migration (after Npgsql switch)
Run from the solution root:
```bash
dotnet ef migrations add InitialCreate \
  --project Bookstore.Data \
  --startup-project Bookstore.Web \
  --output-dir Migrations
```

### Step 3 — The generated migration will already be PostgreSQL-compatible because:
- The `Npgsql` provider is registered
- All entity mappings use lowercase names in `bobsbookstore_dbo` schema
- No SQL Server-specific type overrides exist in the model

### Step 4 — Apply transformation rules to the generated migration file
When the migration is generated, verify:
- [ ] `using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;` is present
- [ ] No `SqlServer:Identity` annotations — should be `Npgsql:ValueGenerationStrategy`
- [ ] All column types are PostgreSQL types (integer, text, timestamp without time zone, etc.)
- [ ] `schema: "bobsbookstore_dbo"` parameter is on all `CreateTable` calls
- [ ] No `nvarchar`, `datetime2`, `bit`, `money`, or other SQL Server types appear

### Step 5 — If migration files are added later, apply these transformation rules per file:

```
a. Replace SQL Server annotations:
   .Annotation("SqlServer:Identity", "1, 1")
   → .Annotation("Npgsql:ValueGenerationStrategy",
                  NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)

b. Table name mappings (from ApplicationDbContext.OnModelCreating):
   "Address"           → "address",          schema: "bobsbookstore_dbo"
   "Book"              → "book",              schema: "bobsbookstore_dbo"
   "Customer"          → "customer",          schema: "bobsbookstore_dbo"
   "Order"             → "order",             schema: "bobsbookstore_dbo"
   "ShoppingCart"      → "shoppingcart",      schema: "bobsbookstore_dbo"
   "ShoppingCartItem"  → "shoppingcartitem",  schema: "bobsbookstore_dbo"
   "OrderItem"         → "orderitem",         schema: "bobsbookstore_dbo"
   "Offer"             → "offer",             schema: "bobsbookstore_dbo"
   "Author"            → "author",            schema: "bobsbookstore_dbo"
   "Product"           → "product",           schema: "bobsbookstore_dbo"
   "ReferenceData"     → "referencedata",     schema: "bobsbookstore_dbo"

c. Data type conversions:
   nvarchar(max) / varchar(max) → text
   nvarchar(n)                  → varchar(n)
   datetime / datetime2         → timestamp without time zone
   datetimeoffset               → timestamp with time zone
   bit                          → boolean
   int                          → integer
   tinyint                      → smallint
   money                        → numeric(19,4)
   uniqueidentifier             → uuid
   varbinary(max)               → bytea

d. All column names already lowercase — no transformation needed.

e. Index names: lowercase and snake_case
   IX_Customer_Sub → ix_customer_sub

f. Foreign key names: lowercase and snake_case
   FK_Book_ReferenceData_PublisherId → fk_book_referencedata_publisherid
```

---

## 8. Summary

| Item | Status |
|---|---|
| Migration files found | ❌ None — no transformation required |
| EF provider already switched to Npgsql | ✅ Confirmed |
| `EnsureCreatedAsync()` compatible with Npgsql | ✅ Fully compatible |
| SQL Server annotations in entities or context | ✅ None found |
| SQL Server type mappings in entities | ✅ None found |
| Schema (`bobsbookstore_dbo`) must be pre-created | ⚠️ Action required before first run |
| `Order` table name casing inconsistency | ⚠️ Advisory for DbContext agent |
| Future migration generation guidance | ✅ Documented above |

**Conclusion:** No migration file transformations are needed. The `EnsureCreatedAsync()`
strategy is compatible with the Npgsql provider as-is. The sole pre-flight action
required is ensuring the `bobsbookstore_dbo` schema exists in the target PostgreSQL
database before the application starts.
