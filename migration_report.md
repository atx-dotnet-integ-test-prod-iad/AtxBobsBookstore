# Final Migration Report: MS SQL Server to PostgreSQL
# BobsBookstore .NET Application

## Migration Summary
- **Date:** 2026-03-21
- **Total SQL Statements Processed:** 5
- **DMS Conversion Results:** 0 successful, 5 failed (all manual conversion with lowercase schema)
- **SQL Equivalency Validation Results:** 0 equivalent, 0 non-equivalent, 5 errors
- **Build Status:** ✅ SUCCESS (0 errors)

---

## DMS Conversion Results

All 5 statements were passed through the DMS MCP statement conversion tool (`dms-mcp___statement_conversion_tool`) with the following parameters:
- **Migration Project:** `arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U`
- **Database:** BobsBookstore
- **Schema:** dbo
- **Region:** us-east-1

All 5 statements failed with the same error:
> "Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again."

All 5 statements were manually converted applying lowercase schema object names per the
`DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA` rule:
- EXEC stored procedure calls → PostgreSQL `SELECT * FROM schema.function()` syntax
- Mixed-case column/table names → lowercase for PostgreSQL compatibility

---

## SQL Equivalency Validation Results

All 5 statement pairs were validated through the SQL Equivalency MCP tool (`sql-equivalency___validate_sql_equivalence`). All returned ERROR with `'uniqueID'` error. Marked as ERROR per transformation definition (tool output only, no agent judgment used).

| # | Status | Error |
|---|--------|-------|
| 1 | ERROR  | 'uniqueID' |
| 2 | ERROR  | 'uniqueID' |
| 3 | ERROR  | 'uniqueID' |
| 4 | ERROR  | 'uniqueID' |
| 5 | ERROR  | 'uniqueID' |

---

## Statement Details

### Statement 1: EditUsingStoredProcedure (AuthorsController.cs, line ~164)
- **Original MS SQL:** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Converted PostgreSQL:** `SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error:** Metadata model creation failed - No objects found
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)

### Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs, line ~188)
- **Original MS SQL:** `SELECT * FROM bobsbookstore_dbo.author`
- **Converted PostgreSQL:** `SELECT * FROM bobsbookstore_dbo.author`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error:** Metadata model creation failed - No objects found
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)

### Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs, line ~210)
- **Original MS SQL:** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Converted PostgreSQL:** `SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error:** Metadata model creation failed - No objects found
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)

### Statement 4: SelectAuthorsByHireYear (AuthorsController.cs, line ~230)
- **Original MS SQL:** `SELECT businessentityid, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;`
- **Converted PostgreSQL:** `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error:** Metadata model creation failed - No objects found
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)

### Statement 5: FindAllProducts (ProductsController.cs, line ~35)
- **Original MS SQL:** `EXEC [dbo].[uspGetProductData];`
- **Converted PostgreSQL:** `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error:** Metadata model creation failed - No objects found
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)

---

## Static Code Migration Status

### Package References ✅
| Project | Package | Status |
|---------|---------|--------|
| Bookstore.Data.csproj | Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ PostgreSQL |
| Bookstore.Web.csproj | Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ PostgreSQL |
| Bookstore.Domain.csproj | No database packages | ✅ N/A |

- No Microsoft.Data.SqlClient or System.Data.SqlClient references exist ✅

### ADO.NET Classes ✅
- No SqlConnection, SqlCommand, SqlDataReader, SqlParameter, SqlTransaction found ✅
- NpgsqlParameter used in AuthorsController.cs and ProductsController.cs ✅
- NpgsqlConnectionStringBuilder used in ServicesSetup.cs ✅

### Connection Strings ✅
- ServicesSetup.cs uses NpgsqlConnectionStringBuilder with Host, Port, Database, Username, Password ✅
- Comment updated from "SQL Server" to "PostgreSQL" ✅
- appsettings.json uses AWS Secrets Manager - no hardcoded connection string ✅

### Using/Import Statements ✅
- No `using Microsoft.Data.SqlClient` or `using System.Data.SqlClient` found ✅
- `using Npgsql;` in AuthorsController.cs, ProductsController.cs, ServicesSetup.cs ✅

### EF Core Configuration ✅
- `UseNpgsql()` used for DbContext configuration in ServicesSetup.cs ✅
- `Npgsql.EnableLegacyTimestampBehavior` switch set in ApplicationDbContext.cs ✅
- All entity mappings use lowercase column/table names with `bobsbookstore_dbo` schema ✅

### Build Status ✅
- Build succeeds with 0 errors
- 156 warnings (all pre-existing: Magick.NET vulnerability warnings and CS0618 deprecation warnings)

---

## Artifacts Generated
1. **extracted_statements.sql** - Catalog of all 5 original MS SQL Server statements with source file locations
2. **converted_statements.sql** - Catalog of all 5 converted PostgreSQL statements with conversion details
3. **sql_equivalency_validation_report.json** - Comprehensive JSON validation report with all 5 statement pairs
4. **migration_report.md** - This comprehensive final migration report

---

## Notes
- All DMS conversions failed due to metadata model creation issues. Manual conversions were applied with lowercase schema object names per the DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA rule.
- All SQL equivalency validations returned ERROR from the tool. These results are recorded as-is from the tool output, with no agent judgment substituted.
- The application code was already partially migrated to PostgreSQL prior to this transformation run. This run verified and documented all conversions through the required DMS and SQL Equivalency tools.
