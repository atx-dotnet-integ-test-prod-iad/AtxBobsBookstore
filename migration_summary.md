# BobsBookstore Migration Summary
## MS SQL Server to PostgreSQL - ADO.NET Application Migration

**Migration Date:** 2026-03-27  
**Application:** BobsBookstore .NET ADO Application  
**Source Database:** Microsoft SQL Server 2019  
**Target Database:** PostgreSQL 13  
**Framework:** .NET 8.0 with Entity Framework Core  

---

## 1. SQL Statement Processing Summary

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Successfully converted by DMS | 0 |
| Manually converted (DMS failure) | 5 |
| Validated as equivalent | 0 |
| Validated as non-equivalent | 0 |
| Equivalency validation errors | 5 |

### DMS Tool Status
All 5 SQL statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`). All 5 failed with the same error:
> Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.

**Conversion Method Applied:** `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`

### SQL Equivalency Tool Status
All 5 statement pairs were validated through the SQL Equivalency MCP tool (`sql-equivalency___validate_sql_equivalence`). All 5 returned ERROR status with `'uniqueID'` error. This is a tool-side issue, not indicative of conversion quality. Per the transformation definition, statuses are recorded exactly as returned by the tool.

---

## 2. Detailed SQL Statement Conversions

### Statement 1: FindAllAuthorsEmbeddedSql
- **Source File:** `AuthorsController.cs` → `FindAllAuthorsEmbeddedSql()`
- **Original (MS SQL):** `SELECT * FROM Author`
- **Converted (PostgreSQL):** `SELECT * FROM bobsbookstore_dbo.author`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Changes:** Added schema prefix `bobsbookstore_dbo`, lowercase table name

### Statement 2: EditUsingStoredProcedure
- **Source File:** `AuthorsController.cs` → `EditUsingStoredProcedure()`
- **Original (MS SQL):** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Converted (PostgreSQL):** `SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Changes:** Converted SQL Server DECLARE/EXEC pattern to PostgreSQL function call syntax, lowercase function name, schema prefix

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File:** `AuthorsController.cs` → `DeleteAuthorEmbeddedSql()`
- **Original (MS SQL):** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Converted (PostgreSQL):** `SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Changes:** Converted SQL Server DECLARE/EXEC pattern to PostgreSQL function call syntax, lowercase function name, schema prefix

### Statement 4: SelectAuthorsByHireYear
- **Source File:** `AuthorsController.cs` → `SelectAuthorsByHireYear()`
- **Original (MS SQL):** `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate`
- **Converted (PostgreSQL):** `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(birthdate)) AS age FROM bobsbookstore_dbo.author WHERE DATE_PART('year', hiredate) = @HireDate;`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Changes:** FORMAT→TO_CHAR, DATEDIFF→DATE_PART+AGE, DATEPART→DATE_PART, GETDATE()→removed (AGE uses current date), lowercase column names/aliases, schema prefix

### Statement 5: FindAllProducts
- **Source File:** `ProductsController.cs` → `FindAllProducts()`
- **Original (MS SQL):** `EXEC [dbo].[uspGetProductData];`
- **Converted (PostgreSQL):** `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Changes:** Converted SQL Server EXEC to PostgreSQL function call syntax, lowercase function name, schema prefix

---

## 3. Statements Requiring Manual Review

All 5 statements require manual review due to:
1. DMS tool failure preventing automated conversion verification
2. SQL Equivalency tool returning ERROR for all statement pairs
3. Manual conversions were applied based on PostgreSQL best practices and lowercase schema mapping rules

**Recommended Review Actions:**
- Verify all stored procedure/function conversions work against the target PostgreSQL database
- Confirm `bobsbookstore_dbo` schema and all referenced functions exist in PostgreSQL
- Test date function conversions (TO_CHAR, DATE_PART, AGE) with actual data

---

## 4. Package Dependency Changes

| Change | From | To |
|--------|------|----|
| Database Provider | `Microsoft.EntityFrameworkCore.SqlServer` | `Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0` |
| Data Client | `Microsoft.Data.SqlClient` | `Npgsql` (via EF Core provider) |

**Files Modified:**
- `Bookstore.Data.csproj` - Replaced SqlServer with Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0
- `Bookstore.Web.csproj` - Replaced SqlServer with Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0

---

## 5. Connection String Changes

| Parameter | SQL Server | PostgreSQL |
|-----------|-----------|------------|
| Builder Class | `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` |
| Server/Host | `Server` | `Host` |
| Port | (default 1433) | `Port` (explicit) |
| Database | `Database` | `Database` |
| Authentication | `User ID` / `Integrated Security` | `Username` / `Password` |

**File Modified:** `ServicesSetup.cs`
- `UseNpgsql()` replaced `UseSqlServer()`
- `NpgsqlConnectionStringBuilder` with Host/Port/Database/Username/Password properties

---

## 6. ADO.NET Class Replacement Summary

| SQL Server Class | PostgreSQL (Npgsql) Equivalent | Files Affected |
|-----------------|-------------------------------|----------------|
| `SqlConnection` | `NpgsqlConnection` | ServicesSetup.cs |
| `SqlCommand` | `NpgsqlCommand` | (not directly used - EF Core) |
| `SqlDataReader` | `NpgsqlDataReader` | (not directly used - EF Core) |
| `SqlParameter` | `NpgsqlParameter` | AuthorsController.cs |
| `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` | ServicesSetup.cs |
| `using Microsoft.Data.SqlClient` | `using Npgsql` | AuthorsController.cs, ProductsController.cs, ServicesSetup.cs |

---

## 7. Additional Changes

### ApplicationDbContext.cs
- Added `using Npgsql.EntityFrameworkCore.PostgreSQL`
- Added `AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true)` for timestamp compatibility
- All entity table mappings use lowercase names with `bobsbookstore_dbo` schema
- All column names mapped to lowercase PostgreSQL equivalents

---

## 8. Build Status

**Final Build:** ✅ Build succeeded (dotnet build BobsBookstore.sln)

**Warnings:** Only pre-existing Magick.NET-Q8-AnyCPU 13.3.0 vulnerability warnings (not migration-related)

---

## 9. Migration Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| `extracted_statements.sql` | Project root | All 5 original MS SQL statements |
| `converted_statements.sql` | Project root | All 5 converted PostgreSQL statements |
| `sql_equivalency_validation_report.json` | Project root | Comprehensive equivalency validation report |
| `migration_summary.md` | Project root | This migration summary document |

---

## 10. Risk Assessment

| Risk | Level | Mitigation |
|------|-------|------------|
| DMS tool unavailable for automated conversion | High | Manual conversion applied with lowercase schema mapping |
| Equivalency tool unable to validate conversions | Medium | All pairs logged as ERROR; manual review recommended |
| Stored procedure compatibility | Medium | Functions need to exist in PostgreSQL as lowercase versions |
| Date function differences | Low | Standard PostgreSQL equivalents used (TO_CHAR, DATE_PART, AGE) |
