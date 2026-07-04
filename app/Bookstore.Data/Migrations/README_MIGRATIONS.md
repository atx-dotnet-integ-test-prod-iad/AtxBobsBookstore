# Bookstore.Data — EF Core Migrations (PostgreSQL)

## Overview

This directory contains the EF Core 8.0 migration files targeting **PostgreSQL** via the
`Npgsql.EntityFrameworkCore.PostgreSQL` provider (v8.0.0).

The initial migration (`20240101000000_InitialPostgres`) was hand-crafted from the
`ApplicationDbContext` model because no prior SQL Server migrations existed in the project.
It is **functionally equivalent** to what `dotnet ef migrations add` would generate once the
project is wired up correctly.

---

## Schema & Provider Configuration

| Setting | Value |
|---------|-------|
| Target schema | `bobsbookstore_dbo` |
| Provider | `Npgsql.EntityFrameworkCore.PostgreSQL` 8.0.0 |
| EF Core version | 8.0.10 |
| Connection setup | `ServicesSetup.cs` → `UseNpgsql(connString)` |
| Legacy timestamp mode | Enabled via `AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true)` |

---

## Tables Created by `InitialPostgres`

| PostgreSQL table | C# entity | Key type | Notes |
|-----------------|-----------|----------|-------|
| `bobsbookstore_dbo.referencedata` | `ReferenceDataItem` | `id` (identity) | Seeded with 24 rows |
| `bobsbookstore_dbo.author` | `Author` | `businessentityid` (identity) | — |
| `bobsbookstore_dbo.product` | `Product` | `productid` (identity) | — |
| `bobsbookstore_dbo.customer` | `Customer` | `id` (identity) | Unique index on `sub` |
| `bobsbookstore_dbo.book` | `Book` | `id` (identity) | FK → referencedata ×4; seeded with 8 rows |
| `bobsbookstore_dbo.address` | `Address` | `id` (identity) | FK → customer |
| `bobsbookstore_dbo.offer` | `Offer` | `id` (identity) | FK → customer + referencedata ×4 |
| `bobsbookstore_dbo.shoppingcart` | `ShoppingCart` | `id` (identity) | — |
| `bobsbookstore_dbo.Order` | `Order` | `id` (identity) | FK → customer (Restrict), address (Cascade) |
| `bobsbookstore_dbo.shoppingcartitem` | `ShoppingCartItem` | `id` (identity) | FK → shoppingcart + book |
| `bobsbookstore_dbo.orderitem` | `OrderItem` | `id` (identity) | FK → Order + book |

### SQL Server → PostgreSQL Type Conversions Applied

| SQL Server type | PostgreSQL type used |
|-----------------|---------------------|
| `int` | `integer` |
| `smallint` | `smallint` |
| `nvarchar(max)` / `nvarchar` (no length) | `text` |
| `nvarchar(n)` | `varchar(n)` |
| `nchar(1)` / `char(1)` | `char(1)` |
| `datetime` / `datetime2` | `timestamp without time zone` |
| `decimal` / `money` | `numeric(18,2)` |
| `bit` (bool stored as int via `.HasConversion<int>()`) | `integer` |
| `SqlServer:Identity` annotation | `Npgsql:ValueGenerationStrategy` = `IdentityByDefaultColumn` |

---

## Applying the Migration

### Prerequisites

1. Ensure `appsettings.json` (or your environment) contains a valid PostgreSQL connection string:

   ```json
   {
     "ConnectionStrings": {
       "BookstoreDbDefaultConnection": "Host=localhost;Port=5432;Database=postgres;Username=postgres;Password=yourpassword"
     }
   }
   ```

2. The schema `bobsbookstore_dbo` will be created automatically by `EnsureSchema()` in the migration.

### Apply via CLI

```bash
# From the repository root
dotnet ef database update \
  --project sourceCode/app/Bookstore.Data \
  --startup-project sourceCode/app/Bookstore.Web
```

### Apply at Application Startup (optional / dev mode)

Add the following to `Program.cs` or `Startup` to auto-migrate on launch:

```csharp
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    db.Database.Migrate();
}
```

---

## Adding Future Migrations

After changing any entity or `ApplicationDbContext`, scaffold a new incremental migration:

```bash
dotnet ef migrations add <MigrationName> \
  --project sourceCode/app/Bookstore.Data \
  --startup-project sourceCode/app/Bookstore.Web
```

Then review the generated file in this `Migrations/` folder to confirm:
- All column types use PostgreSQL equivalents (no `nvarchar`, `datetime2`, `bit`, etc.)
- The `schema: "bobsbookstore_dbo"` parameter is present on all table operations
- `Npgsql:ValueGenerationStrategy` is used instead of `SqlServer:Identity`

Apply the new migration:

```bash
dotnet ef database update \
  --project sourceCode/app/Bookstore.Data \
  --startup-project sourceCode/app/Bookstore.Web
```

---

## Rolling Back

```bash
# Roll back to a specific migration
dotnet ef database update <TargetMigrationName> \
  --project sourceCode/app/Bookstore.Data \
  --startup-project sourceCode/app/Bookstore.Web

# Roll back everything (drops all migrated objects)
dotnet ef database update 0 \
  --project sourceCode/app/Bookstore.Data \
  --startup-project sourceCode/app/Bookstore.Web
```

---

## Files in This Directory

| File | Purpose |
|------|---------|
| `20240101000000_InitialPostgres.cs` | Initial migration — creates all tables, indexes, FKs, and seed data |
| `ApplicationDbContextModelSnapshot.cs` | EF Core model snapshot — used to diff future migrations |
| `README_MIGRATIONS.md` | This file |
