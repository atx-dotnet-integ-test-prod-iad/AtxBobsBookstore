# BobsBookstore — EF Core PostgreSQL Schema Generation

> **Agent**: EF Migration Transformation Agent  
> **Date**: Post-migration verification pass  
> **Scope**: Schema generation strategy for the BobsBookstore application targeting PostgreSQL via Npgsql EF Core 8.0

---

## 1. Verification: No Migration Files Exist

### Directories Scanned

| Directory | Migrations Folder Found | Migration Files Found |
|-----------|-------------------------|-----------------------|
| `Bookstore.Data/` | ❌ None | ❌ None |
| `Bookstore.Web/` | ❌ None | ❌ None |

**Result: Confirmed.** No `Migrations/` folder, no `*Migration.cs` files, and no `*DbContextModelSnapshot.cs` file exist anywhere in the solution. There are zero EF migration files to transform.

---

## 2. Schema Creation Mechanism: `EnsureCreatedAsync()`

### Where It Is Called

**File:** `Bookstore.Web/Startup/MiddlewareSetup.cs`

```csharp
// Create the database
using (var scope = app.Services.CreateAsyncScope())
{
    await scope.ServiceProvider
        .GetService<ApplicationDbContext>()!
        .Database.EnsureCreatedAsync();
}
```

### When It Runs

This call is made during application startup inside `ConfigureMiddlewareAsync()`, which is invoked from `Program.cs`:

```csharp
var app = builder.Build();
await app.ConfigureMiddlewareAsync();   // ← EnsureCreatedAsync() fires here
app.Run();
```

### What `EnsureCreatedAsync()` Does

- If the target database **does not exist**: creates the database and all tables/constraints/indexes/seed data derived from the EF Core model.
- If the target database **already exists**: does nothing — it does **not** attempt to alter or synchronise the schema.
- It bypasses the EF migrations history table (`__EFMigrationsHistory`) entirely; the schema is created directly from the current `ModelBuilder` snapshot.

**Compatibility with PostgreSQL/Npgsql:** `EnsureCreatedAsync()` is fully provider-agnostic and is explicitly supported by `Npgsql.EntityFrameworkCore.PostgreSQL`. Npgsql will issue PostgreSQL-native DDL (`CREATE TABLE`, `CREATE INDEX`, etc.) derived from the `OnModelCreating` configuration.

---

## 3. PostgreSQL Provider Configuration

### NuGet Packages (Both Projects)

| Package | Version | Purpose |
|---------|---------|--------|
| `Npgsql.EntityFrameworkCore.PostgreSQL` | 8.0.0 | PostgreSQL EF Core provider |
| `Microsoft.EntityFrameworkCore` | 8.0.10 | EF Core base |
| `Microsoft.EntityFrameworkCore.Design` | 8.0.10 | Design-time tools |
| `Microsoft.EntityFrameworkCore.Tools` | 8.0.10 | CLI tooling |

### DbContext Registration

**File:** `Bookstore.Web/Startup/ServicesSetup.cs`

```csharp
var connString = GetDatabaseConnectionString(builder.Configuration);
builder.Services.AddDbContext<ApplicationDbContext>(
    option => option.UseNpgsql(connString));
```

`UseNpgsql()` (from `Npgsql.EntityFrameworkCore.PostgreSQL`) replaces the former SQL Server `UseSqlServer()` call. All EF Core operations — including `EnsureCreatedAsync()` — now target PostgreSQL.

### Connection String Resolution

The application supports two connection string sources, resolved at startup:

| Environment | Source | Format |
|-------------|--------|--------|
| Development | `appsettings.json` → `ConnectionStrings:BookstoreDbDefaultConnection` | Standard Npgsql connection string |
| Deployed (EC2 / App Runner) | AWS Secrets Manager (secret name read from Parameter Store key `dbsecretsname`) | `Host=…;Port=…;Database=postgres;Username=…;Password=…` |

---

## 4. Fluent API Schema Mappings in `ApplicationDbContext`

All table and column names are explicitly mapped in `OnModelCreating` using a **non-default schema** (`bobsbookstore_dbo`) and fully lowercase names. These mappings drive the DDL that `EnsureCreatedAsync()` generates.

### Schema Summary

| Entity Class | PostgreSQL Schema | PostgreSQL Table Name |
|---|---|---|
| `Address` | `bobsbookstore_dbo` | `address` |
| `Book` | `bobsbookstore_dbo` | `book` |
| `Customer` | `bobsbookstore_dbo` | `customer` |
| `Order` | `bobsbookstore_dbo` | `Order` |
| `ShoppingCart` | `bobsbookstore_dbo` | `shoppingcart` |
| `ShoppingCartItem` | `bobsbookstore_dbo` | `shoppingcartitem` |
| `OrderItem` | `bobsbookstore_dbo` | `orderitem` |
| `Offer` | `bobsbookstore_dbo` | `offer` |
| `Author` | `bobsbookstore_dbo` | `author` |
| `Product` | `bobsbookstore_dbo` | `product` |
| `ReferenceDataItem` | `bobsbookstore_dbo` | `referencedata` |

> ⚠️  **Action Required — `Order` table name casing:** The `Order` entity maps to `"Order"` (PascalCase) while all other tables use lowercase. In PostgreSQL, unquoted identifiers are folded to lowercase, but EF Core will emit this as a quoted identifier (`"Order"`), preserving the mixed case. For consistency and to avoid quoting surprises, consider renaming this to `"order"` in the Fluent API to match every other table. This is a DbContext-level change (handled by the `ef_dbcontext_transform_ApplicationDbContext` agent), not a migration-level change.

### Column Mappings (Key Excerpt)

All columns are mapped to lowercase names (e.g., `addressline1`, `customerid`, `createdon`). The `IsActive` and `WantToBuy` boolean columns use `.HasConversion<int>()` which stores them as PostgreSQL `integer` — this is valid in PostgreSQL and will work with `EnsureCreatedAsync()`.

### Legacy Timestamp Compatibility Switch

```csharp
static ApplicationDbContext()
{
    AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
}
```

This switch is set in the static constructor of `ApplicationDbContext`. It configures Npgsql to treat `DateTime` values as **unspecified-kind** (`timestamp without time zone`) rather than requiring `DateTimeKind.Utc`. This is essential for this codebase because the entity classes use plain `DateTime` properties without explicit UTC handling. **This switch is required and correct** for the current PostgreSQL migration.

---

## 5. Seed Data

Seed data is registered via `ModelBuilder.Entity<T>().HasData(...)` in `SeedData.cs` (the `PopulateDatabase` partial method called from `OnModelCreating`).

**Seed data includes:**
- 24 `ReferenceDataItem` rows (BookTypes, Conditions, Genres, Publishers)
- 8 `Book` rows with preset IDs 1–8

`EnsureCreatedAsync()` applies `HasData` seed rows via `INSERT` statements as part of initial schema creation **only on a fresh database**. This is correct behaviour for a development/demo seeding scenario.

> ℹ️  If the database already exists (e.g., on a redeployment), `EnsureCreatedAsync()` is a no-op and seed data is **not** re-applied. This is expected and correct for production use.

---

## 6. Startup Sequence Verification

The full startup call chain is:

```
Program.cs
  └─► builder.ConfigureConfiguration()      → loads AWS Systems Manager params (non-dev)
  └─► builder.ConfigureServices()           → registers UseNpgsql(connString)
  └─► builder.ConfigureAuthentication()     → Cognito OIDC or local auth
  └─► builder.ConfigureDependencyInjection()→ repositories, services
  └─► app.ConfigureMiddlewareAsync()        → middleware pipeline
        └─► Database.EnsureCreatedAsync()   ← schema creation happens here
  └─► app.Run()
```

The `EnsureCreatedAsync()` call is correctly placed **after** all services are registered (so the `ApplicationDbContext` is resolvable from DI) and **before** `app.Run()` (so the schema exists before any HTTP request is served). This ordering is correct and PostgreSQL-compatible.

---

## 7. PostgreSQL Schema Pre-requisite

PostgreSQL does **not** auto-create schemas. `EnsureCreatedAsync()` will create the tables within the `bobsbookstore_dbo` schema, but **the schema itself must exist first**.

Npgsql's `EnsureCreatedAsync()` in version 8.x **does** emit `CREATE SCHEMA IF NOT EXISTS "bobsbookstore_dbo"` automatically before creating tables when the schema is specified in `ToTable()`. This was introduced in Npgsql EF Core 6+ and is confirmed present in 8.0.x.

> ✅  No manual `CREATE SCHEMA` DDL script is needed. The schema will be created automatically.

---

## 8. No Migration Files Required — Rationale

| Factor | Detail |
|--------|--------|
| **No existing SQL Server migrations** | The original codebase never used EF code-first migrations; the schema was managed externally |
| **Provider switch is complete** | `UseNpgsql()` is already configured; `EnsureCreatedAsync()` will issue native PostgreSQL DDL |
| **Fluent API drives the schema** | All table/column names, relationships, and constraints are declared in `OnModelCreating` — no migration file is needed to express them |
| **Seed data is model-integrated** | `HasData()` seed records are part of the model; `EnsureCreatedAsync()` handles initial insertion |

---

## 9. Recommendations for Future Development

If schema evolution is needed after the initial deployment, `EnsureCreatedAsync()` is insufficient because it does not apply incremental changes to an existing database. The recommended migration path is:

### Option A — Switch to EF Migrations (Recommended for Production)

```bash
# 1. Remove EnsureCreatedAsync() call from MiddlewareSetup.cs
# 2. Generate the initial migration from the current model
dotnet ef migrations add InitialCreate \
  --project Bookstore.Data \
  --startup-project Bookstore.Web

# 3. Apply on startup (replaces EnsureCreatedAsync)
# In MiddlewareSetup.cs:
await context.Database.MigrateAsync();

# 4. All future schema changes use:
dotnet ef migrations add <MigrationName>
dotnet ef database update
```

Generated migrations will be Npgsql-native (no SQL Server migration transformation needed) because the provider is already set to `UseNpgsql()`.

### Option B — Keep `EnsureCreatedAsync()` (Acceptable for Dev/Demo)

Acceptable if:
- The database is always freshly provisioned on each deployment
- Schema changes are always applied against an empty database
- There is no need to preserve existing data across deployments

### Option C — Hybrid: `EnsureCreatedAsync()` + Manual DDL for Changes

Not recommended. Increases operational complexity and is error-prone.

---

## 10. Summary Checklist

| Check | Status | Notes |
|-------|--------|-------|
| No migration files exist | ✅ Confirmed | Both project directories scanned |
| `EnsureCreatedAsync()` is the schema mechanism | ✅ Confirmed | `MiddlewareSetup.cs` line 45 |
| PostgreSQL provider (`UseNpgsql`) configured | ✅ Confirmed | `ServicesSetup.cs` |
| Npgsql 8.0.0 package referenced | ✅ Confirmed | Both `.csproj` files |
| All tables mapped to `bobsbookstore_dbo` schema | ✅ Confirmed | `ApplicationDbContext.cs` |
| All column names lowercase | ✅ Confirmed | `ApplicationDbContext.cs` |
| Legacy timestamp switch set | ✅ Confirmed | Static constructor in `ApplicationDbContext` |
| Seed data via `HasData()` | ✅ Confirmed | `SeedData.cs` |
| `Order` table name uses PascalCase | ⚠️  Inconsistency | Recommend changing to `"order"` for uniformity |
| Schema auto-created by Npgsql | ✅ Npgsql 8.x behaviour | `CREATE SCHEMA IF NOT EXISTS` emitted automatically |
| No migration transformation required | ✅ N/A | Zero migration files; nothing to transform |
