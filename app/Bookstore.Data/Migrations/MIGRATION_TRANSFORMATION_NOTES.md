# EF Core Migration — PostgreSQL Transformation Notes

## Finding: No Pre-Existing Migration Files

A full scan of `Bookstore.Data/` and all subdirectories confirmed that **no EF Core migration files existed** prior to this transformation. The project relies exclusively on `Database.EnsureCreatedAsync()` (in `MiddlewareSetup.cs`) to create the schema at startup, which bypasses the EF migrations pipeline entirely.

---

## What Was Created

Two PostgreSQL-ready migration files have been scaffolded under `Bookstore.Data/Migrations/`:

| File | Purpose |
|------|---------|
| `20240101000000_InitialCreate.cs` | Full `Up()` / `Down()` migration for all 11 entity tables |
| `ApplicationDbContextModelSnapshot.cs` | EF Core model snapshot (required for future `dotnet ef migrations add` calls) |

---

## Transformation Rules Applied

### 1. Provider Annotation — `SqlServer:Identity` → `Npgsql`
```csharp
// BEFORE (SQL Server)
.Annotation("SqlServer:Identity", "1, 1")

// AFTER (PostgreSQL)
.Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)
```
Applied to every auto-increment primary key column across all 11 tables.

### 2. Using Statement Added
```csharp
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;
```
Required for `NpgsqlValueGenerationStrategy` enum reference in both migration and snapshot files.

### 3. SQL Server → PostgreSQL Data Type Conversions

| SQL Server Type | PostgreSQL Type | Applied To |
|-----------------|-----------------|------------|
| `nvarchar(max)` / `nvarchar` (unbounded) | `text` | All string columns (name, author, email, summary, etc.) |
| `nvarchar(n)` | `varchar(n)` | Bounded strings (nationalidnumber, loginid, jobtitle, maritalstatus, gender, productnumber) |
| `datetime` / `datetime2` | `timestamp without time zone` | All date/time columns (createdon, updatedon, deliverydate, birthdate, hiredate, modifieddate, dateofbirth) |
| `bit` | `boolean` | `wanttobuy` (ShoppingCartItem) |
| `int` (identity) | `integer` + `IdentityByDefaultColumn` | All PK and FK integer columns |
| `smallint` | `smallint` | `vacationhours` (Author) |
| `decimal(18,2)` | `numeric(18,2)` | `price` (Book), `bookprice` (Offer) |

> **Note on `isactive`:** The `Address.IsActive` property uses `.HasConversion<int>()` in `ApplicationDbContext.cs` (bool stored as integer). The migration correctly declares this column as `integer` to match that EF Core value converter.

### 4. Schema: `dbo` → `bobsbookstore_dbo`

All `CreateTable`, `DropTable`, `CreateIndex`, and `AddForeignKey` calls include:
```csharp
schema: "bobsbookstore_dbo"
```
The migration also opens with `migrationBuilder.EnsureSchema(name: "bobsbookstore_dbo")` to guarantee the schema is created before any tables are built.

### 5. Table Name Mappings (from `core_get_schema_mappings_by_file`)

| Entity Class | Target Table Name | Notes |
|---|---|---|
| `Address` | `address` | lowercase |
| `Book` | `book` | lowercase |
| `Customer` | `customer` | lowercase |
| `Order` | `Order` | **Preserved mixed-case** as defined in `ApplicationDbContext` |
| `ShoppingCart` | `shoppingcart` | lowercase |
| `ShoppingCartItem` | `shoppingcartitem` | lowercase |
| `OrderItem` | `orderitem` | lowercase |
| `Offer` | `offer` | lowercase |
| `Author` | `author` | lowercase |
| `Product` | `product` | lowercase |
| `ReferenceDataItem` | `referencedata` | lowercase |

### 6. Index Naming Convention

All indexes follow PostgreSQL snake_case convention (`ix_<table>_<column>`):
```
ix_address_customerid
ix_book_booktypeid / conditionid / genreid / publisherid
ix_customer_sub          (unique)
ix_offer_booktypeid / conditionid / customerid / genreid / publisherid
ix_order_customerid
ix_orderitem_bookid / orderid
ix_shoppingcartitem_bookid / shoppingcartid
```

### 7. Foreign Key Naming Convention

All foreign keys follow PostgreSQL snake_case convention (`fk_<table>_<principaltable>_<column>`):
```
fk_address_customer_customerid
fk_book_referencedata_booktypeid / conditionid / genreid / publisherid
fk_offer_customer_customerid
fk_offer_referencedata_booktypeid / conditionid / genreid / publisherid
fk_order_customer_customerid
fk_orderitem_book_bookid
fk_orderitem_order_orderid
fk_shoppingcartitem_book_bookid
fk_shoppingcartitem_shoppingcart_shoppingcartid
```

### 8. Primary Key Naming Convention

All primary keys follow PostgreSQL snake_case convention (`pk_<table>`).

---

## Table Dependency & Creation Order (Up)

To satisfy all foreign key constraints, tables are created in this order:
1. `referencedata` — no dependencies
2. `author` — no dependencies  
3. `product` — no dependencies
4. `customer` — no dependencies
5. `book` → depends on `referencedata`
6. `address` → depends on `customer`
7. `Order` → depends on `customer`
8. `shoppingcart` — no dependencies
9. `offer` → depends on `customer`, `referencedata`
10. `orderitem` → depends on `book`, `Order`
11. `shoppingcartitem` → depends on `book`, `shoppingcart`

Drop order in `Down()` is the exact reverse.

---

## Recommendation: Transition from EnsureCreatedAsync to Migrations

The current `EnsureCreatedAsync()` call in `MiddlewareSetup.cs` is **incompatible with the EF migrations pipeline** — EF Core will refuse to run `dotnet ef database update` if `EnsureCreatedAsync` has already created the database schema without a `__EFMigrationsHistory` table.

**Recommended change in `MiddlewareSetup.cs`:**

```csharp
// BEFORE
using (var scope = app.Services.CreateAsyncScope())
{
    await scope.ServiceProvider
        .GetService<ApplicationDbContext>()!
        .Database.EnsureCreatedAsync();
}

// AFTER — uses the migrations pipeline
using (var scope = app.Services.CreateAsyncScope())
{
    await scope.ServiceProvider
        .GetService<ApplicationDbContext>()!
        .Database.MigrateAsync();
}
```

`MigrateAsync()` will:
- Create the `bobsbookstore_dbo` schema if it does not exist
- Create the `__EFMigrationsHistory` table
- Apply all pending migrations in order (starting with `InitialCreate`)
- Be a no-op on subsequent restarts if all migrations are already applied

---

## How to Add Future Migrations

Once the PostgreSQL provider is wired up and `MigrateAsync()` is in place, use the standard EF Core tooling:

```bash
# From the solution root or Bookstore.Data directory:
dotnet ef migrations add <MigrationName> \
  --project Bookstore.Data \
  --startup-project Bookstore.Web

# Apply to the database:
dotnet ef database update \
  --project Bookstore.Data \
  --startup-project Bookstore.Web
```

Each generated migration file will be auto-scaffolded with:
- `using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;`  
- `NpgsqlValueGenerationStrategy.IdentityByDefaultColumn` for any new identity columns  
- `schema: "bobsbookstore_dbo"` on all table/index/FK operations  
- PostgreSQL-native column types (`text`, `integer`, `boolean`, `timestamp without time zone`, etc.)

---

## Files Produced

```
Bookstore.Data/
└── Migrations/
    ├── 20240101000000_InitialCreate.cs          ← Up() + Down() migration
    └── ApplicationDbContextModelSnapshot.cs     ← EF model snapshot
```
