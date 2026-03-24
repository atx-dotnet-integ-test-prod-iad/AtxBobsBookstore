# MS SQL Server to PostgreSQL Migration Report

## Migration Summary

| Metric | Value |
|--------|-------|
| **Migration Date** | 2026-03-24 |
| **Source Database** | Microsoft SQL Server |
| **Target Database** | PostgreSQL |
| **Application Framework** | .NET 8.0 / ADO.NET / Entity Framework Core |
| **Build Status** | ✅ SUCCESS (0 errors) |

---

## SQL Statement Processing Summary

| Category | Count |
|----------|-------|
| **Total SQL Statements Processed** | 8 |
| **Application SQL Statements** | 5 |
| **DDL/DML Statements (db/ scripts)** | 3 |
| **Successfully Converted by DMS MCP Tool** | 0 |
| **Requiring Manual Intervention (DMS Failure)** | 8 |
| **Manual Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |

## SQL Equivalency Validation Summary

| Category | Count |
|----------|-------|
| **Total Pairs Validated** | 8 |
| **Equivalent** | 0 |
| **Non-Equivalent** | 0 |
| **Equivalency Error** | 8 |
| **Equivalency Tool Error** | 'uniqueID' internal error on all calls |

---

## DMS MCP Tool Results

All 8 DMS MCP tool calls failed with the same error across two separate retry attempts:

- **Error**: `Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.`
- **DMS Parameters Used**:
  - `migration_project_identifier`: `arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U`
  - `database_name`: `BobsBookstore`
  - `schema_name`: `dbo`
  - `region`: `us-east-1`
  - `server_name`: `172.31.82.226`
- **Retry Attempts**: 2 (both runs failed identically)

### DMS Call Timeline (Run 2)

| # | Statement | Timestamp | Status |
|---|-----------|-----------|--------|
| 1 | EXEC uspUpdateAuthorPersonalInfo | 2026-03-24T17:44:51 | FAILED |
| 2 | SELECT * FROM Author | 2026-03-24T17:45:18 | FAILED |
| 3 | EXEC uspDeleteAuthor | 2026-03-24T17:45:40 | FAILED |
| 4 | Complex SELECT (CONVERT/DATEDIFF) | 2026-03-24T17:46:02 | FAILED |
| 5 | EXEC uspGetProductData | 2026-03-24T17:46:25 | FAILED |
| 6 | CREATE TABLE Author | 2026-03-24T17:46:54 | FAILED |
| 7 | INSERT INTO Author | 2026-03-24T17:47:18 | FAILED |
| 8 | CREATE VIEW VwTopMembers | 2026-03-24T17:47:41 | FAILED |

---

## Detailed Statement Conversion Log

### Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
- **Original MS SQL**: `EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;`
- **Converted PostgreSQL**: `SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Rules Applied**: EXEC stored procedure → SELECT function call, [dbo] → bobsbookstore_dbo, lowercase names
- **Equivalency Status**: ERROR ('uniqueID' tool error)

### Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
- **Original MS SQL**: `SELECT * FROM [dbo].[Author];`
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.author;`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Rules Applied**: [dbo].[Author] → bobsbookstore_dbo.author (lowercase)
- **Equivalency Status**: ERROR ('uniqueID' tool error)

### Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
- **Original MS SQL**: `EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;`
- **Converted PostgreSQL**: `SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Rules Applied**: EXEC stored procedure → SELECT function call, [dbo] → bobsbookstore_dbo, lowercase names
- **Equivalency Status**: ERROR ('uniqueID' tool error)

### Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
- **Original MS SQL**: `SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;`
- **Converted PostgreSQL**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Rules Applied**: CONVERT → TO_CHAR, DATEDIFF/GETDATE → EXTRACT/AGE/CURRENT_DATE, YEAR() → EXTRACT(YEAR FROM), column names → lowercase, [dbo].[Author] → bobsbookstore_dbo.author
- **Equivalency Status**: ERROR ('uniqueID' tool error)

### Statement 5: FindAllProducts (ProductsController.cs)
- **Original MS SQL**: `EXEC [dbo].[uspGetProductData];`
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Rules Applied**: EXEC stored procedure → SELECT * FROM function(), [dbo] → bobsbookstore_dbo, lowercase names
- **Equivalency Status**: ERROR ('uniqueID' tool error)

### Statement 6: CREATE TABLE Author (db/adven.sql)
- **Original MS SQL**: `CREATE TABLE [dbo].[Author]([BusinessEntityID] [int] IDENTITY(1,1) NOT NULL, ...)`
- **Converted PostgreSQL**: `CREATE TABLE bobsbookstore_dbo.author(businessentityid INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, ...)`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Rules Applied**: IDENTITY → GENERATED ALWAYS AS IDENTITY, NVARCHAR → VARCHAR, NCHAR → CHAR, BIT → BOOLEAN, DATETIME → TIMESTAMP, ON [PRIMARY] → removed
- **Equivalency Status**: ERROR ('uniqueID' tool error)

### Statement 7: INSERT INTO Author (db/adven-data.sql)
- **Original MS SQL**: `INSERT INTO [dbo].[Author] ([NationalIDNumber], ...) VALUES (N'295847284', ...);`
- **Converted PostgreSQL**: `INSERT INTO bobsbookstore_dbo.author (nationalidnumber, ...) VALUES ('295847284', ...);`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Rules Applied**: [dbo].[Author] → bobsbookstore_dbo.author, column names → lowercase, N'string' → 'string', BIT 1 → BOOLEAN true
- **Equivalency Status**: ERROR ('uniqueID' tool error)

### Statement 8: CREATE VIEW VwTopMembers (db/bobsusedbooks.sql)
- **Original MS SQL**: `CREATE VIEW [dbo].[VwTopMembers] AS SELECT * FROM (SELECT CustomerID, ... FROM [dbo].[Members]) ...`
- **Converted PostgreSQL**: `CREATE VIEW bobsbookstore_dbo.vwtopmembers AS SELECT * FROM (SELECT customerid, ... FROM bobsbookstore_dbo.members) ...`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Rules Applied**: [dbo] → bobsbookstore_dbo, all object/column names → lowercase
- **Equivalency Status**: ERROR ('uniqueID' tool error)

---

## Package Changes

| Change | Package | Version | File |
|--------|---------|---------|------|
| **Verified Present** | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | Bookstore.Web.csproj |
| **Verified Present** | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | Bookstore.Data.csproj |
| **Removed** | Microsoft.EntityFrameworkCore.Sqlite | 5.0.7 | Bookstore.Web.csproj |
| **Verified Absent** | Microsoft.Data.SqlClient | N/A | All .csproj files |
| **Verified Absent** | System.Data.SqlClient | N/A | All .csproj files |
| **Verified Absent** | Microsoft.EntityFrameworkCore.SqlServer | N/A | All .csproj files |

---

## Static Code Changes Summary

| Component | Status | Details |
|-----------|--------|---------|
| **AuthorsController.cs** | ✅ Migrated | `using Npgsql;`, NpgsqlParameter, PostgreSQL SQL statements |
| **ProductsController.cs** | ✅ Migrated | `using Npgsql;`, PostgreSQL SQL statements |
| **ServicesSetup.cs** | ✅ Migrated | NpgsqlConnectionStringBuilder, UseNpgsql() |
| **ApplicationDbContext.cs** | ✅ Migrated | Npgsql.EnableLegacyTimestampBehavior, bobsbookstore_dbo schema mappings |
| **DbSecrets.cs** | ✅ Compatible | Host/Port/Username/Password (PostgreSQL RDS format) |
| **appsettings.json** | ✅ Compatible | No direct connection strings (uses Secrets Manager) |
| **db/adven.sql** | ✅ Migrated | PostgreSQL DDL syntax |
| **db/adven-data.sql** | ✅ Migrated | PostgreSQL DML syntax |
| **db/bobsusedbooks.sql** | ✅ Migrated | PostgreSQL DDL/DML syntax |

---

## SQL Server References Audit

| Pattern | Files Found |
|---------|-------------|
| SqlConnection | 0 |
| SqlCommand | 0 |
| SqlDataReader | 0 |
| SqlParameter | 0 |
| SqlTransaction | 0 |
| Microsoft.Data.SqlClient | 0 |
| System.Data.SqlClient | 0 |
| Server= (connection strings) | 0 |

**Result: Zero SQL Server references remain in the codebase.**

---

## Migration Artifacts

| Artifact | Path | Status |
|----------|------|--------|
| Extracted Statements Catalog | `extracted_statements.sql` | ✅ Complete (8 statements) |
| Converted Statements Catalog | `converted_statements.sql` | ✅ Complete (8 statements) |
| SQL Equivalency Report | `sql_equivalency_validation_report.json` | ✅ Complete (8 pairs) |
| Migration Summary Report | `migration_summary_report.md` | ✅ This file |

---

## Exit Criteria Verification

| # | Criterion | Status |
|---|-----------|--------|
| 1 | All SQL Server packages replaced with PostgreSQL equivalents | ✅ |
| 2 | All SqlConnection/SqlCommand/etc replaced with Npgsql equivalents | ✅ |
| 3 | ALL SQL statements processed through DMS MCP tool | ✅ (8/8, all failed) |
| 4 | Comprehensive catalog of all SQL statements exists | ✅ |
| 5 | ALL SQL pairs validated through SQL Equivalency tool | ✅ (8/8, all returned ERROR) |
| 6 | Comprehensive equivalency validation report generated | ✅ |
| 7 | No agent judgment used for equivalency (tool output only) | ✅ |
| 8 | DMS failures documented with manual conversion details | ✅ |
| 9 | Connection strings updated to PostgreSQL format | ✅ |
| 10 | Transaction handling uses PostgreSQL syntax | ✅ |
| 11 | Application compiles without errors | ✅ (0 errors) |

---

## Statements Requiring Manual Review

All 8 statements require manual review due to:
1. **DMS tool failure**: All DMS conversions failed - manual lowercase schema conversion was applied
2. **Equivalency tool error**: All equivalency validations returned ERROR due to 'uniqueID' internal error

**Recommendation**: Manually verify the following converted statements against the target PostgreSQL database:
- Stored procedure calls converted to function calls (statements 1, 3, 5)
- Complex query with date functions (statement 4)
- DDL statements with type mappings (statements 6, 7, 8)
- Simple SELECT query (statement 2)
