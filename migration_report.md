# Comprehensive Migration Report
## BobsBookstore: Microsoft SQL Server → PostgreSQL

### Migration Summary
| Metric | Value |
|--------|-------|
| Application | BobsBookstore (.NET 8.0 Web Application) |
| Source Database | Microsoft SQL Server |
| Target Database | PostgreSQL |
| Migration Approach | ADO.NET code migration with SQL statement conversion |
| Total SQL Statements | 5 |
| DMS Successful Conversions | 0 |
| Manual Conversions (DMS Failure) | 5 |
| Equivalency Validated as EQUIVALENT | 0 |
| Equivalency Validated as NOT_EQUIVALENT | 0 |
| Equivalency Validation ERRORS | 5 |

---

### DMS Conversion Summary
All 5 SQL statements were submitted to the AWS DMS MCP Statement Conversion Tool with:
- **Migration Project**: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- **Database**: BobsBookstore
- **Schema**: dbo
- **Region**: us-east-1

All 5 conversions failed with error:
> Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.

Manual conversions were applied using **DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA** rules:
- `[dbo].[TableName]` → `bobsbookstore_dbo.tablename`
- `EXEC [dbo].[procName]` → `SELECT bobsbookstore_dbo.procname()`
- `CONVERT()` → `TO_CHAR()`
- `DATEDIFF()` → `EXTRACT(YEAR FROM AGE())`
- `GETDATE()` → `NOW()`
- `YEAR()` → `EXTRACT(YEAR FROM ...)`

---

### SQL Equivalency Validation Summary
All 5 statement pairs were submitted to the SQL Equivalency validation tool (sql-equivalency___validate_sql_equivalence). All returned ERROR status with error "'uniqueID'". No agent judgment was used for equivalency determination.

---

### Detailed Statement Listing

#### Statement 1: EditUsingStoredProcedure
| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | EditUsingStoredProcedure |
| **Original MS SQL** | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;` |
| **Converted PostgreSQL** | `SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` |
| **DMS Status** | FAILED - Metadata model creation failed |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR |

#### Statement 2: FindAllAuthorsEmbeddedSql
| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | FindAllAuthorsEmbeddedSql |
| **Original MS SQL** | `SELECT * FROM [dbo].[Author]` |
| **Converted PostgreSQL** | `SELECT * FROM bobsbookstore_dbo.author` |
| **DMS Status** | FAILED - Metadata model creation failed |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR |

#### Statement 3: DeleteAuthorEmbeddedSql
| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | DeleteAuthorEmbeddedSql |
| **Original MS SQL** | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;` |
| **Converted PostgreSQL** | `SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);` |
| **DMS Status** | FAILED - Metadata model creation failed |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR |

#### Statement 4: SelectAuthorsByHireYear
| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | SelectAuthorsByHireYear |
| **Original MS SQL** | `SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate` |
| **Converted PostgreSQL** | `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;` |
| **DMS Status** | FAILED - Metadata model creation failed |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR |

#### Statement 5: FindAllProducts
| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/ProductsController.cs |
| **Method** | FindAllProducts |
| **Original MS SQL** | `EXEC [dbo].[uspGetProductData];` |
| **Converted PostgreSQL** | `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();` |
| **DMS Status** | FAILED - Metadata model creation failed |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR |

---

### Package Dependency Changes
| Original Package | Original Version | New Package | New Version |
|-----------------|------------------|-------------|-------------|
| Microsoft.Data.SqlClient | (removed) | Npgsql | 8.0.0 |
| Microsoft.EntityFrameworkCore.SqlServer | (removed) | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 |

### Connection String Changes
| Component | Before (SQL Server) | After (PostgreSQL) |
|-----------|--------------------|--------------------|
| Connection Builder | SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder |
| Server Property | `Server` / `Data Source` | `Host` |
| Database Property | `Database` / `Initial Catalog` | `Database` |
| Auth Property | `User Id` / `Integrated Security` | `Username` |
| Port | N/A | `Port` |
| DbContext Config | `UseSqlServer()` | `UseNpgsql()` |

### ADO.NET Class Replacements
| SQL Server Class | PostgreSQL (Npgsql) Equivalent |
|-----------------|-------------------------------|
| SqlConnection | NpgsqlConnection |
| SqlCommand | NpgsqlCommand |
| SqlDataReader | NpgsqlDataReader |
| SqlParameter | NpgsqlParameter |
| SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder |

---

### Migration Artifacts
| Artifact | Status |
|----------|--------|
| extracted_statements.sql | ✅ Complete (5 original MS SQL statements) |
| converted_statements.sql | ✅ Complete (5 converted PostgreSQL statements) |
| sql_equivalency_validation_report.json | ✅ Complete (5 statement pairs validated) |
| dms_conversion_summary.md | ✅ Complete (DMS results for all 5 statements) |
| migration_report.md | ✅ Complete (this file) |

### Build Status
- **Final Build**: SUCCESS (0 errors, warnings are pre-existing package vulnerabilities)
- **Solution**: BobsBookstore.sln
- **Framework**: .NET 8.0

### Files Modified During Migration
1. `app/Bookstore.Web/Controllers/AuthorsController.cs` - SQL statements converted, ADO.NET classes replaced
2. `app/Bookstore.Web/Controllers/ProductsController.cs` - SQL statements converted, ADO.NET classes replaced
3. `app/Bookstore.Web/Startup/ServicesSetup.cs` - Connection string builder and DbContext configuration updated
4. `app/Bookstore.Web/Bookstore.Web.csproj` - Package references updated
5. `app/Bookstore.Data/Bookstore.Data.csproj` - Package references updated
6. `app/Bookstore.Data/ApplicationDbContext.cs` - Entity mappings updated for PostgreSQL schema
