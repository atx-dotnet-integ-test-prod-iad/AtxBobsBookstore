# BobsBookstore Migration Report
## Microsoft SQL Server to PostgreSQL Migration

### Migration Summary

| Metric | Count |
|--------|-------|
| Total SQL Statements Processed | 5 |
| Statements Successfully Converted by DMS MCP Tool | 0 |
| Statements Requiring Manual Intervention (DMS Failure) | 5 |
| Statements Validated as Equivalent (SQL Equivalency Tool) | 0 |
| Statements Validated as Non-Equivalent | 0 |
| Statements with Equivalency Validation Errors | 5 |

### DMS MCP Tool Results

All 5 SQL statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`) with:
- **Schema Name**: `dbo`
- **Region**: `us-east-1`
- **Database Name**: `BobsBookstore`
- **Server Name**: `172.31.82.226`
- **Migration Project**: `arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U`

**All 5 conversions failed** with the same error:
> Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}

**DMS Retry Timestamps:**
- Statement 1: 2026-03-06T09:37:49.510881 (FAILED)
- Statement 2: 2026-03-06T09:38:05.226302 (FAILED)
- Statement 3: 2026-03-06T09:38:20.996543 (FAILED)
- Statement 4: 2026-03-06T09:38:36.580687 (FAILED)
- Statement 5: 2026-03-06T09:38:52.115738 (FAILED)

Per the transformation rules, all statements were manually converted with lowercase schema object names (conversion method: `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`).

### SQL Equivalency Tool Results

All 5 statement pairs were validated through the SQL Equivalency tool (`sql-equivalency___validate_sql_equivalence`).

**All 5 validations returned ERROR** with:
> {"equivalence_status": "ERROR", "error": "'uniqueID'"}

**Equivalency Validation Timestamps:**
- Statement 1: 2026-03-06T09:42:44.723550 (ERROR)
- Statement 2: 2026-03-06T09:42:46.027254 (ERROR)
- Statement 3: 2026-03-06T09:42:47.109007 (ERROR)
- Statement 4: 2026-03-06T09:42:48.185315 (ERROR)
- Statement 5: 2026-03-06T09:42:49.246035 (ERROR)

No agent judgment was used to determine equivalency. All statuses are directly from the tool output.

### Detailed Statement Conversions

#### Statement 1: EditUsingStoredProcedure (AuthorsController.cs:~167)
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `EditUsingStoredProcedure()`
- **Original (MS SQL)**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed: The selected objects were not found.
- **Equivalency Status**: ERROR (from tool)
- **Requires Manual Review**: Yes

#### Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs:~192)
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `FindAllAuthorsEmbeddedSql()`
- **Original (MS SQL)**:
  ```sql
  SELECT * FROM Author
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM author
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed: The selected objects were not found.
- **Equivalency Status**: ERROR (from tool)
- **Requires Manual Review**: Yes

#### Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs:~210)
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `DeleteAuthorEmbeddedSql()`
- **Original (MS SQL)**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM uspdeleteauthor(@BusinessEntityID);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed: The selected objects were not found.
- **Equivalency Status**: ERROR (from tool)
- **Requires Manual Review**: Yes

#### Statement 4: SelectAuthorsByHireYear (AuthorsController.cs:~228)
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `SelectAuthorsByHireYear()`
- **Original (MS SQL)**:
  ```sql
  SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed: The selected objects were not found.
- **Equivalency Status**: ERROR (from tool)
- **Requires Manual Review**: Yes
- **Conversion Details**:
  - `FORMAT(date, 'yyyy-MM-dd HH:mm:ss')` → `TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')`
  - `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT`
  - `DATEPART(YEAR, HireDate)` → `EXTRACT(YEAR FROM hiredate)`
  - `GETDATE()` → `NOW()`

#### Statement 5: FindAllProducts (ProductsController.cs:~36)
- **Source File**: `app/Bookstore.Web/Controllers/ProductsController.cs`
- **Method**: `FindAllProducts()`
- **Original (MS SQL)**:
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM uspgetproductdata();
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed: The selected objects were not found.
- **Equivalency Status**: ERROR (from tool)
- **Requires Manual Review**: Yes

### Files Modified

| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | 4 SQL statements use PostgreSQL equivalents; 7 NpgsqlParameter instances; using Npgsql import |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | 1 SQL statement uses PostgreSQL equivalent; using Npgsql import |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | UseNpgsql for DbContext; NpgsqlConnectionStringBuilder; PostgreSQL connection string format |
| `app/Bookstore.Data/Bookstore.Data.csproj` | Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0; No SqlServer packages |
| `app/Bookstore.Web/Bookstore.Web.csproj` | Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0; No SqlServer packages |

### Package References Verification

| Package | Status | Project |
|---------|--------|---------|
| Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ Present | Bookstore.Data.csproj |
| Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ Present | Bookstore.Web.csproj |
| Microsoft.EntityFrameworkCore.SqlServer | ✅ Not present (removed) | All .csproj files |
| Microsoft.Data.SqlClient | ✅ Not present (removed) | All .csproj files |
| System.Data.SqlClient | ✅ Not present | All .csproj files |

### Static Code Verification

| Check | Result | Details |
|-------|--------|---------|
| SqlConnection | ✅ None found | No SQL Server connection classes |
| SqlCommand | ✅ None found | No SQL Server command classes |
| SqlDataReader | ✅ None found | No SQL Server reader classes |
| SqlParameter | ✅ None found | All replaced with NpgsqlParameter |
| using Microsoft.Data.SqlClient | ✅ None found | Replaced with using Npgsql |
| using System.Data.SqlClient | ✅ None found | Not present |
| UseSqlServer | ✅ None found | Replaced with UseNpgsql |
| SqlConnectionStringBuilder | ✅ None found | Replaced with NpgsqlConnectionStringBuilder |

### Connection String Configuration

| Parameter | Value | Status |
|-----------|-------|--------|
| Host | `{dbSecrets.Host}` | ✅ PostgreSQL format |
| Port | `{dbSecrets.Port}` | ✅ PostgreSQL format |
| Database | `BobsUsedBookStore` | ✅ PostgreSQL format |
| Username | `{dbSecrets.Username}` | ✅ NpgsqlConnectionStringBuilder property |
| Password | `{dbSecrets.Password}` | ✅ NpgsqlConnectionStringBuilder property |
| Builder Class | NpgsqlConnectionStringBuilder | ✅ PostgreSQL builder |
| DbContext Config | UseNpgsql | ✅ PostgreSQL provider |

### Build Status

**Final build: SUCCEEDED** with 0 errors.

### Transformation Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| `extracted_statements.sql` | Project root | All 5 original MS SQL statements with comprehensive documentation |
| `converted_statements.sql` | Project root | All 5 converted PostgreSQL statements with DMS results |
| `sql_equivalency_validation_report.json` | Project root | Comprehensive equivalency validation report with all 5 statement pairs |
| `migration_report.md` | Project root | This comprehensive migration report |
