# BobsBookstore: MS SQL Server to PostgreSQL Migration Report

## Migration Summary

| Metric | Value |
|--------|-------|
| **Migration Date** | 2026-03-05 |
| **Application** | BobsBookstore (.NET 8.0 Web Application) |
| **Source Database** | Microsoft SQL Server |
| **Target Database** | PostgreSQL |
| **Migration Status** | ✅ Complete (Build Successful) |

---

## SQL Statement Conversion Summary

| Metric | Count |
|--------|-------|
| **Total SQL Statements Processed** | 5 |
| **Statements Successfully Converted by DMS** | 0 |
| **Statements Requiring Manual Intervention (DMS Failure)** | 5 |
| **Statements Validated as Equivalent** | 0 |
| **Statements Validated as Non-Equivalent** | 0 |
| **Statements with Equivalency Validation Error** | 5 |

### DMS Tool Details
- **Tool**: dms-mcp___statement_conversion_tool
- **Migration Project**: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- **Error**: All 5 statements failed with "Metadata model creation failed: The selected objects were not found."
- **Fallback**: Manual conversion applied using DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA methodology

### SQL Equivalency Tool Details
- **Tool**: sql-equivalency___validate_sql_equivalence
- **Error**: All 5 statement pairs returned ERROR with "'uniqueID'" error (systemic tool issue)
- **Verification**: Diagnostic test with trivial `SELECT 1` / `SELECT 1` pair confirmed systemic tool failure

---

## SQL Statement Conversion Details

### Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
- **Original (MS SQL)**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Converted (PostgreSQL)**: `SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Changes**: DECLARE/EXEC stored procedure pattern → SELECT from PostgreSQL function call

### Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
- **Original (MS SQL)**: `SELECT * FROM bobsbookstore_dbo.author`
- **Converted (PostgreSQL)**: `SELECT * FROM bobsbookstore_dbo.author`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Changes**: No syntax changes needed (already PostgreSQL compatible)

### Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
- **Original (MS SQL)**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Converted (PostgreSQL)**: `SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Changes**: DECLARE/EXEC stored procedure pattern → SELECT from PostgreSQL function call

### Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
- **Original (MS SQL)**: `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;`
- **Converted (PostgreSQL)**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Changes**:
  - `FORMAT()` → `TO_CHAR()`
  - `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT`
  - `DATEPART(YEAR, HireDate)` → `EXTRACT(YEAR FROM hiredate)`
  - `GETDATE()` → `NOW()`
  - Column names converted to lowercase

### Statement 5: FindAllProducts (ProductsController.cs)
- **Original (MS SQL)**: `EXEC [dbo].[uspGetProductData];`
- **Converted (PostgreSQL)**: `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Changes**: EXEC stored procedure → SELECT from PostgreSQL function call

---

## Static Code Changes

### Package Dependencies
| Package | Status |
|---------|--------|
| Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ Already present in Bookstore.Data.csproj and Bookstore.Web.csproj |
| Microsoft.Data.SqlClient | ✅ Not present (already removed) |
| System.Data.SqlClient | ✅ Not present (already removed) |

### ADO.NET Class Replacements
| Original (SQL Server) | Replacement (PostgreSQL) | Count | Status |
|----------------------|-------------------------|-------|--------|
| SqlParameter | NpgsqlParameter | 7 | ✅ Replaced |
| SqlConnection | NpgsqlConnection | 0 | ✅ Not applicable (not in codebase) |
| SqlCommand | NpgsqlCommand | 0 | ✅ Not applicable (not in codebase) |
| SqlDataReader | NpgsqlDataReader | 0 | ✅ Not applicable (not in codebase) |

### Connection Configuration
| Component | Status |
|-----------|--------|
| UseNpgsql() in ServicesSetup.cs | ✅ Already present |
| NpgsqlConnectionStringBuilder in ServicesSetup.cs | ✅ Already present |
| PostgreSQL connection parameters (Host, Port, Database, Username, Password) | ✅ Already configured |

---

## Files Modified

| File | Changes |
|------|---------|
| app/Bookstore.Web/Controllers/AuthorsController.cs | 4 SQL statements converted; 7 SqlParameter → NpgsqlParameter replacements |
| app/Bookstore.Web/Controllers/ProductsController.cs | 1 SQL statement converted |

## Artifacts Generated

| Artifact | Description |
|----------|-------------|
| extracted_statements.sql | Catalog of all 5 original MS SQL statements |
| converted_statements.sql | Catalog of all 5 converted PostgreSQL statements |
| sql_equivalency_validation_report.json | Complete equivalency validation report for all 5 statement pairs |
| migration_report.md | This comprehensive migration report |

---

## Build Validation

- **Final Build Status**: ✅ Build succeeded
- **Errors**: 0
- **Warnings**: Pre-existing warnings related to Magick.NET-Q8-AnyCPU package vulnerabilities and deprecated ISystemClock usage (not related to this migration)

## Remaining SQL Server Artifacts Check

| Check | Result |
|-------|--------|
| SqlParameter in *.cs | ✅ None found |
| SqlConnection in *.cs | ✅ None found |
| SqlCommand in *.cs | ✅ None found |
| SqlDataReader in *.cs | ✅ None found |
| Microsoft.Data.SqlClient in *.cs | ✅ None found |
| System.Data.SqlClient in *.cs | ✅ None found |
| UseSqlServer in *.cs | ✅ None found |
| Microsoft.Data.SqlClient in *.csproj | ✅ None found |
