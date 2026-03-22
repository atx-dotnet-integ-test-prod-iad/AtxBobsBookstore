# BobsBookstore - SQL Server to PostgreSQL Migration Report

## Migration Summary

| Metric | Value |
|--------|-------|
| **Migration Date** | 2026-03-22 |
| **Application** | BobsBookstore .NET 8.0 Web Application |
| **Source Database** | Microsoft SQL Server 2019 |
| **Target Database** | PostgreSQL 13 (via Npgsql) |
| **Total SQL Statements Processed** | 5 |
| **DMS Conversion Successes** | 0 |
| **DMS Conversion Failures** | 5 |
| **Manual Conversions (Lowercase Schema)** | 5 |
| **Equivalency Validated as EQUIVALENT** | 0 |
| **Equivalency Validated as NOT_EQUIVALENT** | 0 |
| **Equivalency Validated as ERROR** | 5 |

## 1. Package Dependencies

### Verified NuGet Packages

| Project | Package | Version | Status |
|---------|---------|---------|--------|
| Bookstore.Data.csproj | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | ✅ Verified |
| Bookstore.Web.csproj | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | ✅ Verified |
| Bookstore.Domain.csproj | (No DB dependencies) | N/A | ✅ Verified |

### SQL Server Packages Removed
- `Microsoft.Data.SqlClient` - **NOT PRESENT** (confirmed removed) ✅
- `System.Data.SqlClient` - **NOT PRESENT** (confirmed removed) ✅

## 2. Using Statements / Imports

| File | Import | Status |
|------|--------|--------|
| AuthorsController.cs | `using Npgsql;` | ✅ Verified |
| ProductsController.cs | `using Npgsql;` | ✅ Verified |
| ServicesSetup.cs | `using Npgsql;` | ✅ Verified |

### SQL Server References Search
- `SqlConnection` - **NONE FOUND** ✅
- `SqlCommand` - **NONE FOUND** ✅
- `SqlDataReader` - **NONE FOUND** ✅
- `SqlParameter` - **NONE FOUND** ✅
- `SqlTransaction` - **NONE FOUND** ✅
- `Microsoft.Data.SqlClient` - **NONE FOUND** ✅
- `System.Data.SqlClient` - **NONE FOUND** ✅

## 3. Connection String Configuration

| Component | Configuration | Status |
|-----------|--------------|--------|
| ServicesSetup.cs | Uses `NpgsqlConnectionStringBuilder` | ✅ Verified |
| ServicesSetup.cs | Uses `Host`, `Port`, `Database`, `Username`, `Password` | ✅ Verified |
| DbContext Registration | Uses `option.UseNpgsql(connString)` | ✅ Verified |
| SQL Server Patterns | `Server=`, `Integrated Security`, `UseSqlServer` | ✅ None Found |

## 4. Entity Framework Configuration

### ApplicationDbContext.cs
- `Npgsql.EnableLegacyTimestampBehavior` switch: ✅ Set to `true`
- All entities mapped to `bobsbookstore_dbo` schema: ✅ Verified

### Database Schema Mapping

| Entity | Table Name | Schema | Status |
|--------|-----------|--------|--------|
| Address | address | bobsbookstore_dbo | ✅ Lowercase |
| Book | book | bobsbookstore_dbo | ✅ Lowercase |
| Customer | customer | bobsbookstore_dbo | ✅ Lowercase |
| **Order** | **Order** | **bobsbookstore_dbo** | ⚠️ PascalCase (reflects actual PostgreSQL schema) |
| ShoppingCart | shoppingcart | bobsbookstore_dbo | ✅ Lowercase |
| ShoppingCartItem | shoppingcartitem | bobsbookstore_dbo | ✅ Lowercase |
| OrderItem | orderitem | bobsbookstore_dbo | ✅ Lowercase |
| Offer | offer | bobsbookstore_dbo | ✅ Lowercase |
| Author | author | bobsbookstore_dbo | ✅ Lowercase |
| Product | product | bobsbookstore_dbo | ✅ Lowercase |
| ReferenceData | referencedata | bobsbookstore_dbo | ✅ Lowercase |

> **Note**: The `Order` entity uses PascalCase table name `"Order"`. This is intentional and reflects the actual PostgreSQL schema where "Order" is a reserved word requiring case-sensitive quoting.

## 5. SQL Statement Conversion Details

### Statement 1: EditUsingStoredProcedure
- **File**: AuthorsController.cs
- **Method**: EditUsingStoredProcedure
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Converted PostgreSQL**: `SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **DMS Status**: FAILED (Metadata model creation failed) - Attempted 2026-03-22T16:36:51
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error at 2026-03-22T16:41:22)

### Statement 2: FindAllAuthorsEmbeddedSql
- **File**: AuthorsController.cs
- **Method**: FindAllAuthorsEmbeddedSql
- **Original MS SQL**: `SELECT * FROM [dbo].[Author]`
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.author`
- **DMS Status**: FAILED (Metadata model creation failed) - Attempted 2026-03-22T16:37:14
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error at 2026-03-22T16:41:32)

### Statement 3: DeleteAuthorEmbeddedSql
- **File**: AuthorsController.cs
- **Method**: DeleteAuthorEmbeddedSql
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Converted PostgreSQL**: `SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **DMS Status**: FAILED (Metadata model creation failed) - Attempted 2026-03-22T16:37:37
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error at 2026-03-22T16:41:42)

### Statement 4: SelectAuthorsByHireYear
- **File**: AuthorsController.cs
- **Method**: SelectAuthorsByHireYear
- **Original MS SQL**: `SELECT BusinessEntityID, CONVERT(VARCHAR(10), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEDIFF(YEAR, HireDate, GETDATE()) >= @HireDate`
- **Converted PostgreSQL**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, hiredate))::INTEGER >= @HireDate;`
- **DMS Status**: FAILED (Metadata model creation failed) - Attempted 2026-03-22T16:38:01
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Notes**: 
  - `CONVERT(VARCHAR(10), col, 120)` → `TO_CHAR(col, 'YYYY-MM-DD HH24:MI:SS')`
  - `DATEDIFF(YEAR, col, GETDATE())` → `EXTRACT(YEAR FROM AGE(CURRENT_DATE, col))::INTEGER`
  - `GETDATE()` → `CURRENT_DATE`
  - WHERE clause preserved: `>=` operator maintained from original MS SQL
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error at 2026-03-22T16:41:58)

### Statement 5: FindAllProducts
- **File**: ProductsController.cs
- **Method**: FindAllProducts
- **Original MS SQL**: `EXEC [dbo].[uspGetProductData];`
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **DMS Status**: FAILED (Metadata model creation failed) - Attempted 2026-03-22T16:38:28
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error at 2026-03-22T16:42:07)

## 6. DMS Tool Results

All 5 statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`) with parameters:
- `schema_name='dbo'`
- `database_name='BobsBookstore'`
- `migration_project_identifier='arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U'`
- `region='us-east-1'`

All 5 failed with the same error:

```
Metadata model creation failed: No objects were found according to the specified selection rules.
Please review your selection rules and try again.
```

Since DMS failed for all statements, manual conversion was applied using lowercase schema object names per the transformation definition rules (`DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`).

## 7. SQL Equivalency Validation Results

All 5 statement pairs were validated through the SQL Equivalency tool (`sql-equivalency___validate_sql_equivalence`). All 5 returned ERROR status with error `'uniqueID'`. No agent judgment was used to determine equivalency - all statuses reported are exactly as returned by the tool.

The full equivalency report is available at: `sourceCode/sql_equivalency_validation_report.json`

## 8. Build Verification

| Build Step | Result |
|-----------|--------|
| `dotnet build BobsBookstore.sln` | ✅ **Build Succeeded** |
| Compilation Errors | 0 |
| Warnings | 158 (all from pre-existing Magick.NET-Q8-AnyCPU 13.3.0 vulnerability warnings) |

## 9. Artifacts Generated

| Artifact | Location | Description |
|----------|----------|-------------|
| Extracted Statements Catalog | `sourceCode/extracted_statements.sql` | All 5 original MS SQL statements |
| Converted Statements Catalog | `sourceCode/converted_statements.sql` | All 5 original + converted PostgreSQL statements with DMS timestamps |
| SQL Equivalency Report | `sourceCode/sql_equivalency_validation_report.json` | Comprehensive JSON report with all 5 statement pairs |
| Migration Summary | `sourceCode/migration_summary.md` | This report |

## 10. Items Requiring Manual Review

1. **DMS Tool Availability**: All 5 DMS conversions failed with metadata model creation error. The DMS migration project may not have the correct source database schema configured. Manual review of the DMS migration project configuration is recommended.

2. **SQL Equivalency Tool**: All 5 equivalency validations returned ERROR with `'uniqueID'` error. The tool may have connectivity or configuration issues. Manual equivalency review of the 5 statement pairs is recommended.

3. **Order Table Casing**: The `Order` entity maps to PascalCase table name `"Order"` while all other entities use lowercase. This should be verified against the actual PostgreSQL schema.

4. **Statement 4 WHERE Clause**: The original MS SQL uses `DATEDIFF(YEAR, HireDate, GETDATE()) >= @HireDate` and the converted PostgreSQL uses `EXTRACT(YEAR FROM AGE(CURRENT_DATE, hiredate))::INTEGER >= @HireDate`. Note that `DATEDIFF(YEAR, ...)` counts the number of year boundaries crossed (calendar year difference) while `EXTRACT(YEAR FROM AGE(...))` calculates the actual elapsed years. This may produce slightly different results for dates near year boundaries.
