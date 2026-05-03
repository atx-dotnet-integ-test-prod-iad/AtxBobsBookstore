# PostgreSQL Initial Migration - Scaffolding Instructions

## Status

**No existing EF migration files were found.**
The Migrations/ folder did not exist prior to this step. This document records:

1. The confirmed absence of any SQL Server-era migrations requiring transformation.
2. The exact CLI commands and verification steps needed to scaffold a fresh
   InitialCreate migration targeting PostgreSQL.

---

## Pre-flight Checklist

Before running `dotnet ef migrations add`, confirm all prior transformation
steps have been completed:

| Step | File / Component | Expected State |
|------|-----------------|----------------|
| 1 | Bookstore.Data/Bookstore.Data.csproj | References Npgsql.EntityFrameworkCore.PostgreSQL v8.0.0, no Microsoft.EntityFrameworkCore.SqlServer |
| 2 | Bookstore.Data/ApplicationDbContext.cs | Calls AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true); all entities mapped to schema bobsbookstore_dbo with lowercase table/column names |
| 3 | All domain entity classes | No SQL Server-specific attributes; data annotations use PostgreSQL-compatible types |
| 4 | Bookstore.Web/Program.cs (or ServicesSetup.cs) | UseNpgsql(...) replaces UseSqlServer(...) |
| 5 | Connection string | Points to a live PostgreSQL instance |

---

## Scaffold Command

Run from the solution root (the directory containing Bookstore.Data/ and Bookstore.Web/):

```bash
dotnet ef migrations add InitialCreate \
  --project Bookstore.Data \
  --startup-project Bookstore.Web \
  --output-dir Migrations \
  --context ApplicationDbContext
```

### Windows (PowerShell)

```powershell
dotnet ef migrations add InitialCreate `
  --project Bookstore.Data `
  --startup-project Bookstore.Web `
  --output-dir Migrations `
  --context ApplicationDbContext
```

---

## Expected Output Files

After a successful scaffold, Bookstore.Data/Migrations/ will contain:

```
Migrations/
  <timestamp>_InitialCreate.cs            # Up() / Down() migration logic
  <timestamp>_InitialCreate.Designer.cs   # EF snapshot metadata
  ApplicationDbContextModelSnapshot.cs    # Current model snapshot
```

---

## Required Characteristics of the Generated Migration

### Identity / Auto-increment Columns

Must use NpgsqlValueGenerationStrategy.IdentityByDefaultColumn, NOT SqlServer:Identity:

```csharp
// CORRECT
.Annotation("Npgsql:ValueGenerationStrategy",
            NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)

// WRONG - must not appear
.Annotation("SqlServer:Identity", "1, 1")
```

### Schema

Every CreateTable call must carry schema: "bobsbookstore_dbo":

```csharp
migrationBuilder.CreateTable(
    name: "address",
    schema: "bobsbookstore_dbo",
    columns: table => new { ... });
```

### Data Types - SQL Server to PostgreSQL Mapping

| SQL Server type       | PostgreSQL type expected         |
|-----------------------|----------------------------------|
| nvarchar(max)         | text                             |
| nvarchar(n)           | varchar(n)                       |
| datetime / datetime2  | timestamp without time zone      |
| datetimeoffset        | timestamp with time zone         |
| bit                   | integer (see boolean note below) |
| int                   | integer                          |
| decimal(p,s) / money  | numeric(p,s)                     |
| uniqueidentifier      | uuid                             |
| varbinary(max)        | bytea                            |

NOTE: Address.IsActive and ShoppingCartItem.WantToBuy are mapped with
.HasConversion<int>() in ApplicationDbContext. The scaffold will generate
these columns as integer, which is correct.

### Table and Column Names

All names must be lowercase matching the HasColumnName / ToTable calls
in ApplicationDbContext:

| Entity           | Table name       | Schema              |
|------------------|-----------------|---------------------|
| Address          | address          | bobsbookstore_dbo   |
| Book             | book             | bobsbookstore_dbo   |
| Customer         | customer         | bobsbookstore_dbo   |
| Order            | Order            | bobsbookstore_dbo   |
| ShoppingCart     | shoppingcart     | bobsbookstore_dbo   |
| ShoppingCartItem | shoppingcartitem | bobsbookstore_dbo   |
| OrderItem        | orderitem        | bobsbookstore_dbo   |
| Offer            | offer            | bobsbookstore_dbo   |
| Author           | author           | bobsbookstore_dbo   |
| Product          | product          | bobsbookstore_dbo   |
| ReferenceDataItem| referencedata    | bobsbookstore_dbo   |

### Using Statements

The generated migration file must include:

```csharp
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;
```

It must NOT include:

```csharp
using Microsoft.EntityFrameworkCore.SqlServer.Metadata;
```

---

## Post-scaffold Verification Steps

After running the scaffold command, open Migrations/<timestamp>_InitialCreate.cs
and verify:

1. No SqlServer:Identity annotations  - search for "SqlServer" and expect zero hits.
2. All CreateTable calls have schema: "bobsbookstore_dbo" - search for "CreateTable("
   and confirm every occurrence has the schema argument.
3. Data types are PostgreSQL-native - search for nvarchar, datetime2, bit,
   uniqueidentifier; expect zero hits.
4. Npgsql:ValueGenerationStrategy present - every auto-increment id column
   should carry this annotation.
5. ApplicationDbContextModelSnapshot.cs generated - confirms the snapshot
   baseline is established for future incremental migrations.

---

## Applying the Migration to the Database

Once the migration is scaffolded and verified:

```bash
dotnet ef database update \
  --project Bookstore.Data \
  --startup-project Bookstore.Web \
  --context ApplicationDbContext
```

This will:
1. Create the schema bobsbookstore_dbo if it does not exist.
2. Create all 11 tables with their PostgreSQL-compatible columns.
3. Insert all seed data defined in SeedData.cs via PopulateDatabase(modelBuilder).
4. Create the __EFMigrationsHistory table to track applied migrations.

---

## Troubleshooting

### Design-time factory not found

If the tooling cannot instantiate ApplicationDbContext at design time, add a
design-time factory to Bookstore.Data:

```csharp
// Bookstore.Data/ApplicationDbContextFactory.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Bookstore.Data
{
    public class ApplicationDbContextFactory : IDesignTimeDbContextFactory<ApplicationDbContext>
    {
        public ApplicationDbContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
            optionsBuilder.UseNpgsql(
                "Host=localhost;Database=bookstore;Username=postgres;Password=yourpassword");
            return new ApplicationDbContext(optionsBuilder.Options);
        }
    }
}
```

### Schema does not exist error at database update

PostgreSQL does not auto-create schemas. Run this once before database update:

```sql
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;
```

Or add it as a raw SQL step at the top of the migration Up() method:

```csharp
protected override void Up(MigrationBuilder migrationBuilder)
{
    migrationBuilder.EnsureSchema(name: "bobsbookstore_dbo");
    // ... rest of generated Up() ...
}
```

NOTE: EF Core's Npgsql provider automatically emits migrationBuilder.EnsureSchema()
for any schema referenced in ToTable(...) calls, so this is usually handled
automatically in the generated migration.

---

## Summary

| Item                            | Value                                   |
|---------------------------------|-----------------------------------------|
| EF Version                      | EF Core 8                               |
| Npgsql provider                 | Npgsql.EntityFrameworkCore.PostgreSQL v8.0.0 |
| DbContext                       | ApplicationDbContext (Bookstore.Data)   |
| Target schema                   | bobsbookstore_dbo                       |
| Migration name                  | InitialCreate                           |
| Output directory                | Bookstore.Data/Migrations/              |
| Existing migrations transformed | 0 (none existed)                        |
| SQL Server types to convert     | See type-mapping table above            |
