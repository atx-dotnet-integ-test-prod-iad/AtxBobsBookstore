# SQL Server to PostgreSQL Migration Report

## BobsBookstore .NET Application
**Date:** 2026-03-22  
**Migration Type:** MS SQL Server → PostgreSQL  
**Framework:** .NET 8.0 / ASP.NET Core with Entity Framework Core  

---

## 1. Executive Summary

This report documents the migration of the BobsBookstore .NET application from Microsoft SQL Server to PostgreSQL. The migration involved:
- Extracting and converting 5 SQL statements from T-SQL to PostgreSQL syntax
- Attempting DMS MCP tool conversion for all 5 statements (all failed due to metadata model creation error)
- Applying manual conversion with lowercase schema mapping as fallback
- Validating all 5 statement pairs through the SQL Equivalency tool (all returned ERROR due to tool-level 'uniqueID' issue)
- Verifying all static dependencies (packages, imports, connection strings, ADO.NET classes)
- Confirming the application builds successfully with all PostgreSQL equivalents in place

---

## 2. SQL Statement Conversion Summary

| Metric | Count |
|--------|-------|
| **Total SQL Statements Processed** | 5 |
| **Successfully Converted by DMS MCP Tool** | 0 |
| **Requiring Manual Intervention (DMS Failure)** | 5 |
| **Validated as Equivalent** | 0 |
| **Validated as Non-Equivalent** | 0 |
| **Equivalency Validation Errors** | 5 |

---

## 3. DMS Tool Conversion Details

All 5 statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`) with the following parameters:
- `schema_name`: `dbo`
- `region`: `us-east-1`
- `migration_project_identifier`: `arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U`

**DMS Error (all 5 statements):**
```
Metadata model creation failed: {'error': "Metadata model creation failed: 
{'default_error_details': {'message': 'No objects were found according to the 
specified selection rules. Please review your selection rules and try again.'}}"}
```

Manual conversion with lowercase schema mapping rules was applied as per the transformation definition fallback procedure (`DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`).

### DMS Conversion Timestamps:
| Statement | DMS Timestamp |
|-----------|--------------|
| Statement 1 (SELECT * FROM Author) | 2026-03-22T12:59:10.609146 |
| Statement 2 (SELECT with date functions) | 2026-03-22T12:59:26.046972 |
| Statement 3 (EXEC uspUpdateAuthorPersonalInfo) | 2026-03-22T12:59:53.307530 |
| Statement 4 (EXEC uspDeleteAuthor) | 2026-03-22T13:00:08.705068 |
| Statement 5 (EXEC uspGetProductData) | 2026-03-22T13:00:24.179821 |

---

## 4. Statement-by-Statement Conversion Details

### Statement 1: FindAllAuthorsEmbeddedSql()
| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `FindAllAuthorsEmbeddedSql()` |
| **Original MS SQL** | `SELECT * FROM [dbo].[Author]` |
| **Converted PostgreSQL** | `SELECT * FROM bobsbookstore_dbo.author` |
| **DMS Status** | FAILED |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool returned 'uniqueID' error) |
| **Equivalency Timestamp** | 2026-03-22T13:01:28.843691 |
| **Manual Conversion Notes** | Table name lowercased, schema mapped from `dbo` to `bobsbookstore_dbo` |

### Statement 2: SelectAuthorsByHireYear()
| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `SelectAuthorsByHireYear()` |
| **Original MS SQL** | `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate` |
| **Converted PostgreSQL** | `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(NOW(), birthdate))::int AS age FROM bobsbookstore_dbo.author WHERE DATE_PART('year', hiredate) = @HireDate;` |
| **DMS Status** | FAILED |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool returned 'uniqueID' error) |
| **Equivalency Timestamp** | 2026-03-22T13:01:29.891766 |
| **Manual Conversion Notes** | FORMAT() → TO_CHAR(), DATEDIFF() → DATE_PART/AGE/NOW(), DATEPART() → DATE_PART(), column names lowercased, schema mapped |

### Statement 3: EditUsingStoredProcedure()
| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `EditUsingStoredProcedure()` |
| **Original MS SQL** | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;` |
| **Converted PostgreSQL** | `SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` |
| **DMS Status** | FAILED |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool returned 'uniqueID' error) |
| **Equivalency Timestamp** | 2026-03-22T13:01:49.719568 |
| **Manual Conversion Notes** | T-SQL DECLARE/EXEC/SELECT pattern → PostgreSQL SELECT function() call, function name lowercased, schema mapped |

### Statement 4: DeleteAuthorEmbeddedSql()
| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `DeleteAuthorEmbeddedSql()` |
| **Original MS SQL** | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;` |
| **Converted PostgreSQL** | `SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);` |
| **DMS Status** | FAILED |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool returned 'uniqueID' error) |
| **Equivalency Timestamp** | 2026-03-22T13:01:50.768389 |
| **Manual Conversion Notes** | T-SQL DECLARE/EXEC/SELECT pattern → PostgreSQL SELECT function() call, function name lowercased, schema mapped |

### Statement 5: FindAllProducts()
| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/ProductsController.cs` |
| **Method** | `FindAllProducts()` |
| **Original MS SQL** | `EXEC [dbo].[uspGetProductData];` |
| **Converted PostgreSQL** | `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();` |
| **DMS Status** | FAILED |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool returned 'uniqueID' error) |
| **Equivalency Timestamp** | 2026-03-22T13:01:51.813538 |
| **Manual Conversion Notes** | T-SQL EXEC → PostgreSQL SELECT * FROM function() call, function name lowercased, schema mapped |

---

## 5. SQL Equivalency Validation Results

All 5 statement pairs were submitted to the SQL Equivalency MCP tool (`sql-equivalency___validate_sql_equivalence`). All returned ERROR status due to a tool-level 'uniqueID' error. Per the transformation definition, agent judgment was NOT used to determine equivalency - all statuses come exclusively from the tool output.

| Metric | Count |
|--------|-------|
| Total Statements Validated | 5 |
| Equivalent | 0 |
| Non-Equivalent | 0 |
| Error | 5 |

**Full equivalency report:** See `sql_equivalency_validation_report.json`

---

## 6. Static Dependency Verification

### 6.1 Package References

| Project | Package | Version | Status |
|---------|---------|---------|--------|
| Bookstore.Web | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | ✅ Present |
| Bookstore.Data | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | ✅ Present |
| All Projects | Microsoft.Data.SqlClient | - | ✅ Not Present |
| All Projects | System.Data.SqlClient | - | ✅ Not Present |
| All Projects | Microsoft.EntityFrameworkCore.SqlServer | - | ✅ Not Present |

### 6.2 Using Statements

| File | Import | Status |
|------|--------|--------|
| AuthorsController.cs | `using Npgsql;` | ✅ Present |
| ProductsController.cs | `using Npgsql;` | ✅ Present |
| ServicesSetup.cs | `using Npgsql;` | ✅ Present |
| All .cs files | `using Microsoft.Data.SqlClient;` | ✅ Not Present |
| All .cs files | `using System.Data.SqlClient;` | ✅ Not Present |

### 6.3 ADO.NET Class Replacements

| Original Class | PostgreSQL Replacement | Status |
|----------------|----------------------|--------|
| SqlParameter | NpgsqlParameter | ✅ Replaced |
| SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder | ✅ Replaced |
| SqlConnection | N/A (not used in codebase) | ✅ N/A |
| SqlCommand | N/A (not used in codebase) | ✅ N/A |
| SqlDataReader | N/A (not used in codebase) | ✅ N/A |

### 6.4 Connection String Configuration

| Component | Expected | Actual | Status |
|-----------|----------|--------|--------|
| Connection String Builder | NpgsqlConnectionStringBuilder | NpgsqlConnectionStringBuilder | ✅ Match |
| DB Context Provider | UseNpgsql | UseNpgsql | ✅ Match |
| Host Parameter | Host = dbSecrets.Host | Present | ✅ Match |
| Port Parameter | Port = dbSecrets.Port | Present | ✅ Match |
| Database | "postgres" | "postgres" | ✅ Match |
| UseSqlServer | Not Present | Not Present | ✅ Match |
| Server= / Data Source= | Not Present | Not Present | ✅ Match |

### 6.5 ApplicationDbContext Configuration

| Feature | Status |
|---------|--------|
| Npgsql Legacy Timestamp Behavior | ✅ Enabled |
| Schema 'bobsbookstore_dbo' for all entities | ✅ Configured |
| Lowercase column names in HasColumnName() | ✅ Configured |
| Bool HasConversion<int>() for IsActive | ✅ Present |
| Bool HasConversion<int>() for WantToBuy | ✅ Present |

### 6.6 Transaction Handling

No transaction handling patterns (BeginTransaction/CommitTransaction/RollbackTransaction) were found in the codebase. No changes needed.

---

## 7. Artifacts Generated

| Artifact | Path | Description |
|----------|------|-------------|
| Extracted Statements | `extracted_statements.sql` | Complete catalog of all 5 original MS SQL statements |
| Converted Statements | `converted_statements.sql` | Complete catalog of all 5 converted PostgreSQL statements with DMS timestamps |
| Equivalency Report | `sql_equivalency_validation_report.json` | JSON report with all 5 statement pairs and tool results |
| Migration Report | `migration_report.md` | This comprehensive report |

### Artifact Completeness Verification
- ✅ EVERY SQL statement in the codebase is accounted for (5/5)
- ✅ EVERY statement has been through DMS tool (5/5 attempted, 5/5 documented as failed)
- ✅ EVERY statement pair has been through SQL Equivalency tool (5/5 validated)
- ✅ No agent judgment was used for equivalency - all from tool output
- ✅ All SQL Server packages replaced with Npgsql
- ✅ All ADO.NET classes replaced with Npgsql equivalents
- ✅ Connection strings use PostgreSQL format

---

## 8. Build Verification

**Final Build Status:** ✅ SUCCESS  
**Build Command:** `dotnet build BobsBookstore.sln`  
**Errors:** 0  
**Warnings:** Pre-existing warnings only (deprecated API warnings)

---

## 9. Known Limitations and Recommendations

1. **DMS Tool Failure:** All 5 DMS conversion attempts failed due to metadata model creation issues (`No objects were found according to the specified selection rules`). Manual conversion with lowercase schema mapping rules was applied. Future DMS tool runs should be attempted if the tool configuration is resolved.

2. **SQL Equivalency Validation:** All 5 statement pairs returned ERROR from the SQL Equivalency tool due to a persistent tool-level 'uniqueID' error. Manual review of the converted statements is strongly recommended.

3. **Stored Procedures:** The stored procedure calls (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData) have been converted to PostgreSQL function call syntax. The actual stored procedures/functions must exist in the PostgreSQL database for the application to work at runtime.

4. **TODO Comments:** Stored procedure TODO comments have been preserved in the code as reminders that the PostgreSQL functions need to be created/verified in the database.

5. **Runtime Testing:** While the application compiles successfully, runtime testing against a PostgreSQL database is required to verify:
   - All SELECT queries return expected results
   - All stored procedure/function calls execute correctly
   - Connection string configuration works with the target PostgreSQL instance
   - Data types are properly mapped between the application and PostgreSQL
