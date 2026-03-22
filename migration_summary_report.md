# BobsBookstore: MS SQL Server to PostgreSQL Migration Summary Report

## Migration Overview

| Attribute | Value |
|-----------|-------|
| **Application** | BobsBookstore (.NET 8.0 Web Application) |
| **Source Database** | Microsoft SQL Server 2019 |
| **Target Database** | PostgreSQL 13 |
| **DMS Migration Project** | `arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U` |
| **Source Database Name** | BobsUsedBookStore |
| **Target Schema** | bobsusedbookstore_dbo |
| **Build Status** | ✅ SUCCESS (0 errors, 184 pre-existing warnings) |

---

## SQL Statement Processing Summary

| Metric | Count |
|--------|-------|
| **Total SQL Statements Processed** | 5 |
| **DMS Conversion Successful** | 3 |
| **DMS Conversion Failed (Manual Conversion)** | 2 |
| **Equivalency Validated as EQUIVALENT** | 0 |
| **Equivalency Validated as NOT_EQUIVALENT** | 0 |
| **Equivalency Validation ERROR** | 5 |

---

## Detailed SQL Statement Conversion Results

### Statement 1: EditUsingStoredProcedure
- **Source File**: `AuthorsController.cs`
- **Method**: `EditUsingStoredProcedure`
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Converted PostgreSQL**: `SELECT bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Method**: `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`
- **DMS Error**: `Metadata model creation failed: Statement definition is not valid.`
- **Reason for Manual Conversion**: DMS cannot handle multi-statement blocks (DECLARE/EXEC/SELECT pattern)
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source File**: `AuthorsController.cs`
- **Method**: `FindAllAuthorsEmbeddedSql`
- **Original MS SQL**: `SELECT * FROM Author`
- **Converted PostgreSQL**: `SELECT * FROM bobsusedbookstore_dbo.author;`
- **Conversion Method**: `DMS_TOOL`
- **DMS Output**: Success - schema qualified with lowercase table name
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File**: `AuthorsController.cs`
- **Method**: `DeleteAuthorEmbeddedSql`
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Converted PostgreSQL**: `SELECT bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Conversion Method**: `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`
- **DMS Error**: `Metadata model creation failed: Statement definition is not valid.`
- **Reason for Manual Conversion**: DMS cannot handle multi-statement blocks (DECLARE/EXEC/SELECT pattern)
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)

### Statement 4: SelectAuthorsByHireYear
- **Source File**: `AuthorsController.cs`
- **Method**: `SelectAuthorsByHireYear`
- **Original MS SQL**: `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;`
- **Converted PostgreSQL**: `SELECT businessentityid, to_char(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;`
- **Conversion Method**: `DMS_TOOL`
- **DMS Output**: Success (GenAI-assisted conversion)
- **Function Mappings Applied by DMS**:
  - `FORMAT()` → `to_char()`
  - `DATEDIFF()` → `aws_sqlserver_ext.datediff()`
  - `GETDATE()` → `clock_timestamp()`
  - `DATEPART()` → `date_part()`
  - Schema `[dbo].[Author]` → `bobsusedbookstore_dbo.author`
- **Note**: DMS dropped the `@` prefix from `@HireDate` parameter; restored for C# parameterized query compatibility
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)

### Statement 5: FindAllProducts
- **Source File**: `ProductsController.cs`
- **Method**: `FindAllProducts`
- **Original MS SQL**: `EXEC [dbo].[uspGetProductData];`
- **Converted PostgreSQL**: `CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);`
- **Conversion Method**: `DMS_TOOL`
- **DMS Output**: Success - EXEC converted to CALL with cursor parameter
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)

---

## Files Modified

| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | Updated SQL statements to PostgreSQL syntax, replaced SqlParameter with NpgsqlParameter, added `using Npgsql;` |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | Updated SQL statement to PostgreSQL syntax, added `using Npgsql;` |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | Replaced `UseSqlServer()` with `UseNpgsql()`, `SqlConnectionStringBuilder` with `NpgsqlConnectionStringBuilder`, updated connection string format, added `using Npgsql;` |
| `app/Bookstore.Data/Bookstore.Data.csproj` | Replaced `Microsoft.EntityFrameworkCore.SqlServer` with `Npgsql.EntityFrameworkCore.PostgreSQL` 8.0.0 |
| `app/Bookstore.Web/Bookstore.Web.csproj` | Replaced `Microsoft.EntityFrameworkCore.SqlServer` with `Npgsql.EntityFrameworkCore.PostgreSQL` 8.0.0 |

---

## Package Dependency Changes

| Original Package | Version | Replacement Package | Version |
|-----------------|---------|-------------------|---------|
| `Microsoft.EntityFrameworkCore.SqlServer` | (removed) | `Npgsql.EntityFrameworkCore.PostgreSQL` | 8.0.0 |

---

## ADO.NET Class Replacements

| SQL Server Class | PostgreSQL Replacement | Count |
|-----------------|----------------------|-------|
| `SqlParameter` | `NpgsqlParameter` | 7 instances |
| `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` | 1 instance |
| `UseSqlServer()` | `UseNpgsql()` | 1 instance |
| `using Microsoft.Data.SqlClient` | `using Npgsql` | 3 files |

---

## Connection String Changes

| Parameter | SQL Server | PostgreSQL |
|-----------|-----------|------------|
| Host/Server | `Server=` | `Host=` |
| Database | `Database=` | `Database=` |
| Authentication | `UserID=` | `Username=` |
| SSL | N/A | `SSL Mode=Prefer;Trust Server Certificate=true` |
| Builder | `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` |

---

## Statements Requiring Manual Review

All 5 statements returned ERROR from the SQL Equivalency validation tool. The error message was consistently `'uniqueID'` across all statements. This appears to be a systematic error in the equivalency tool rather than an indication of incorrect conversions. Manual review is recommended for all statements:

1. **Statement 1 & 3**: Stored procedure EXEC patterns manually converted to PostgreSQL function calls - verify stored procedures exist in target schema
2. **Statement 4**: Complex query with date functions converted by DMS using GenAI - verify function behavior matches expected output
3. **Statement 5**: Stored procedure with cursor parameter - verify procedure signature matches in target schema

---

## Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| Extracted Statements | `extracted_statements.sql` | All 5 original MS SQL Server statements |
| Converted Statements | `converted_statements.sql` | All 5 converted PostgreSQL statements with conversion method |
| Equivalency Report | `sql_equivalency_validation_report.json` | Detailed validation results for all 5 statement pairs |
| Build Log | `build.log` | dotnet build output showing successful build |
| Migration Summary | `migration_summary_report.md` | This report |
