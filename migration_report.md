# Migration Report: SQL Server to PostgreSQL
## BobsBookstore .NET Application
## Generated: 2026-03-25

### Migration Summary
| Metric | Value |
|--------|-------|
| Total SQL Statements Processed | 5 |
| Statements Successfully Converted by DMS | 0 |
| Statements Requiring Manual Conversion | 5 |
| Manual Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| Statements Validated as Equivalent | 0 |
| Statements Validated as Non-Equivalent | 0 |
| Statements with Equivalency Validation Errors | 5 |
| DMS Attempts per Statement | 2 (both failed) |

### DMS Conversion Results
All 5 SQL statements were submitted to the DMS MCP tool (dms-mcp___statement_conversion_tool) **twice** with:
- `database_name`: BobsBookstore
- `schema_name`: dbo
- `region`: us-east-1

**Attempt #1 Timestamps**: 2026-03-25T01:14:26 through 2026-03-25T01:15:54
**Attempt #2 Timestamps**: 2026-03-25T01:44:50 through 2026-03-25T01:46:35

**Result**: All 10 attempts (5 statements × 2 attempts) failed with the same error:
> Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.

### Manual Conversions Applied
Since DMS failed for all statements across both attempts, manual conversion was applied using the `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA` method:

| # | Original MS SQL | Converted PostgreSQL | Source File | Method |
|---|-----------------|---------------------|-------------|--------|
| 1 | `EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender` | `UPDATE bobsbookstore_dbo.author SET nationalidnumber = @NationalIDNumber, birthdate = @BirthDate, maritalstatus = @MaritalStatus, gender = @Gender WHERE businessentityid = @BusinessEntityID` | AuthorsController.cs | EditUsingStoredProcedure |
| 2 | `SELECT * FROM [dbo].[Author]` | `SELECT * FROM bobsbookstore_dbo.author` | AuthorsController.cs | FindAllAuthorsEmbeddedSql |
| 3 | `EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID` | `DELETE FROM bobsbookstore_dbo.author WHERE businessentityid = @BusinessEntityID` | AuthorsController.cs | DeleteAuthorEmbeddedSql |
| 4 | `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEPART(YEAR, HireDate) = @HireDate` | `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate` | AuthorsController.cs | SelectAuthorsByHireYear |
| 5 | `EXEC [dbo].[uspGetProductData]` | `SELECT productid, name, productnumber, safetystocklevel FROM bobsbookstore_dbo.product` | ProductsController.cs | FindAllProducts |

### SQL Equivalency Validation Results
All 5 statement pairs were submitted to the SQL Equivalency MCP tool (sql-equivalency___validate_sql_equivalence).

**Result**: All 5 pairs returned ERROR status with error: `'uniqueID'`

| # | Equivalency Status | Timestamp |
|---|-------------------|-----------|
| 1 | ERROR | 2026-03-25T01:48:37 |
| 2 | ERROR | 2026-03-25T01:48:47 |
| 3 | ERROR | 2026-03-25T01:48:56 |
| 4 | ERROR | 2026-03-25T01:49:07 |
| 5 | ERROR | 2026-03-25T01:49:16 |

Per the transformation definition, equivalency status is determined exclusively by the tool output. Agent judgment was NOT used.

### Static Code Migration Verification

#### Package References
- ✅ No `Microsoft.Data.SqlClient` or `System.Data.SqlClient` references in any .csproj files
- ✅ `Npgsql.EntityFrameworkCore.PostgreSQL` Version 8.0.0 present in:
  - `app/Bookstore.Data/Bookstore.Data.csproj`
  - `app/Bookstore.Web/Bookstore.Web.csproj`
- ✅ `app/Bookstore.Domain/Bookstore.Domain.csproj` has no SQL Server packages

#### ADO.NET Class Replacements
- ✅ No `SqlConnection` classes found (all use EF Core DbContext)
- ✅ No `SqlCommand` classes found (all use ExecuteSqlRawAsync/SqlQueryRaw)
- ✅ No `SqlDataReader` classes found
- ✅ No `SqlParameter` classes found (all replaced with `NpgsqlParameter`)
- ✅ All `using` statements reference `Npgsql`, no `SqlClient` imports
- ✅ No remaining SQL Server remnants in the entire codebase

#### Connection String Configuration
- ✅ `ServicesSetup.cs` uses `UseNpgsql` for DbContext registration
- ✅ `ServicesSetup.cs` uses `NpgsqlConnectionStringBuilder` with Host, Port, Database, Username, Password properties
- ✅ `ApplicationDbContext.cs` uses `Npgsql.EnableLegacyTimestampBehavior` switch
- ✅ No SQL Server connection string patterns remain (no Server=, Integrated Security=, etc.)

#### Entity Framework Configuration
- ✅ All entity table mappings use lowercase table names in `bobsbookstore_dbo` schema
- ✅ All column mappings use lowercase column names
- ✅ All entities mapped: Address, Book, Customer, Order, ShoppingCart, ShoppingCartItem, OrderItem, Offer, Author, Product, ReferenceDataItem

### Files Modified During Migration
1. `app/Bookstore.Web/Controllers/AuthorsController.cs` - SQL statements, NpgsqlParameter, using Npgsql
2. `app/Bookstore.Web/Controllers/ProductsController.cs` - SQL statement, using Npgsql
3. `app/Bookstore.Data/ApplicationDbContext.cs` - Entity mappings, Npgsql.EnableLegacyTimestampBehavior, lowercase table/column names
4. `app/Bookstore.Web/Startup/ServicesSetup.cs` - UseNpgsql, NpgsqlConnectionStringBuilder, using Npgsql
5. `app/Bookstore.Data/Bookstore.Data.csproj` - Npgsql.EntityFrameworkCore.PostgreSQL package
6. `app/Bookstore.Web/Bookstore.Web.csproj` - Npgsql.EntityFrameworkCore.PostgreSQL package
7. `app/Bookstore.Domain/Authors/Author.cs` - PostgreSQL column/table annotations
8. `app/Bookstore.Domain/Products/Product.cs` - PostgreSQL column/table annotations

### Items Requiring Manual Review
1. **DMS Tool Availability**: All 5 DMS conversion attempts failed across 2 rounds (10 total attempts). The error "Metadata model creation failed" suggests the migration project metadata/selection rules may need adjustment. Manual review recommended.
2. **SQL Equivalency Validation**: All 5 equivalency validations returned ERROR with `'uniqueID'` error. This appears to be a systemic tool issue rather than actual SQL incompatibility. Manual verification of SQL equivalency is recommended.
3. **Stored Procedure Conversions**: Statements 1, 3, and 5 involved stored procedures that were manually converted to direct SQL statements. The stored procedure logic should be verified against the original stored procedure implementations.

### Transformation Artifacts
1. `extracted_statements.sql` - Complete catalog of all 5 original MS SQL statements
2. `converted_statements.sql` - Complete catalog of all 5 converted PostgreSQL statements with DMS attempt documentation
3. `sql_equivalency_validation_report.json` - Comprehensive equivalency validation report with exact tool output
4. `migration_report.md` - This report
5. `migration_log.md` - Detailed per-statement migration log

### Build Status
- **Final Build**: ✅ Success (0 errors, 156 warnings)
- Warnings are pre-existing (NU1901/NU1902/NU1903 package vulnerability warnings for Magick.NET-Q8-AnyCPU v13.3.0)
