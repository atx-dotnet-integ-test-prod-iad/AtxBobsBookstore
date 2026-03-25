# Migration Log - BobsBookstore SQL Server to PostgreSQL

## Overview
This document records every SQL statement processed during the migration, including DMS MCP tool outputs and any manual interventions.

## DMS Configuration
- **Migration Project ARN**: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- **Source Database**: BobsBookstore
- **Schema**: dbo
- **Region**: us-east-1
- **Server**: 172.31.82.226

---

## Statement 1: FindAllAuthorsEmbeddedSql

### Source Location
- **File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: FindAllAuthorsEmbeddedSql()
- **Line**: 187

### Original MS SQL Statement
```sql
SELECT * FROM [dbo].[Author]
```

### DMS MCP Tool Output
```json
{
  "conversion_timestamp": "2026-03-25T19:10:16.327088",
  "input": {
    "sql_text": "SELECT * FROM [dbo].[Author]",
    "migration_project_identifier": "arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U",
    "database_name": "BobsBookstore",
    "schema_name": "dbo",
    "region": "us-east-1",
    "server_name": "172.31.82.226"
  },
  "status": "error",
  "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}\"}"
}
```

### Manual Conversion
- **Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Converted PostgreSQL Statement**:
```sql
SELECT * FROM bobsbookstore_dbo.author
```
- **Conversion Notes**: Schema `[dbo]` mapped to `bobsbookstore_dbo`. Table name `[Author]` lowercased to `author`. Matches ApplicationDbContext.cs entity mapping.

### SQL Equivalency Tool Output
```json
{
  "equivalence_status": "ERROR",
  "error": "'uniqueID'",
  "timestamp": "2026-03-25T19:13:23.418506"
}
```

---

## Statement 2: EditUsingStoredProcedure

### Source Location
- **File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: EditUsingStoredProcedure()
- **Line**: 163

### Original MS SQL Statement
```sql
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
```

### DMS MCP Tool Output
```json
{
  "conversion_timestamp": "2026-03-25T19:11:18.073416",
  "input": {
    "sql_text": "EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender",
    "migration_project_identifier": "arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U",
    "database_name": "BobsBookstore",
    "schema_name": "dbo",
    "region": "us-east-1",
    "server_name": "172.31.82.226"
  },
  "status": "error",
  "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}\"}"
}
```

### Manual Conversion
- **Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Converted PostgreSQL Statement**:
```sql
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
```
- **Conversion Notes**: SQL Server `EXEC` stored procedure call converted to PostgreSQL function call syntax `SELECT * FROM schema.function(params)`. Schema `[dbo]` mapped to `bobsbookstore_dbo`. Procedure name lowercased.

### SQL Equivalency Tool Output
```json
{
  "equivalence_status": "ERROR",
  "error": "'uniqueID'",
  "timestamp": "2026-03-25T19:13:58.220955"
}
```

---

## Statement 3: DeleteAuthorEmbeddedSql

### Source Location
- **File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: DeleteAuthorEmbeddedSql()
- **Line**: 208

### Original MS SQL Statement
```sql
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
```

### DMS MCP Tool Output
```json
{
  "conversion_timestamp": "2026-03-25T19:11:42.386196",
  "input": {
    "sql_text": "EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID",
    "migration_project_identifier": "arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U",
    "database_name": "BobsBookstore",
    "schema_name": "dbo",
    "region": "us-east-1",
    "server_name": "172.31.82.226"
  },
  "status": "error",
  "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}\"}"
}
```

### Manual Conversion
- **Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Converted PostgreSQL Statement**:
```sql
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
```
- **Conversion Notes**: SQL Server `EXEC` stored procedure call converted to PostgreSQL function call syntax. Schema and procedure name lowercased.

### SQL Equivalency Tool Output
```json
{
  "equivalence_status": "ERROR",
  "error": "'uniqueID'",
  "timestamp": "2026-03-25T19:14:08.832837"
}
```

---

## Statement 4: SelectAuthorsByHireYear

### Source Location
- **File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: SelectAuthorsByHireYear()
- **Line**: 228

### Original MS SQL Statement
```sql
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate
```

### DMS MCP Tool Output
```json
{
  "conversion_timestamp": "2026-03-25T19:12:05.293571",
  "input": {
    "sql_text": "SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate",
    "migration_project_identifier": "arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U",
    "database_name": "BobsBookstore",
    "schema_name": "dbo",
    "region": "us-east-1",
    "server_name": "172.31.82.226"
  },
  "status": "error",
  "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}\"}"
}
```

### Manual Conversion
- **Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Converted PostgreSQL Statement**:
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
```
- **Conversion Notes**:
  - `CONVERT(VARCHAR, ModifiedDate, 120)` → `TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')` (style 120 = ODBC canonical yyyy-mm-dd hh:mi:ss)
  - `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER`
  - `YEAR(HireDate)` → `EXTRACT(YEAR FROM hiredate)`
  - `GETDATE()` → `CURRENT_DATE`
  - All column names and aliases lowercased for PostgreSQL compatibility
  - Schema `[dbo]` mapped to `bobsbookstore_dbo`

### SQL Equivalency Tool Output
```json
{
  "equivalence_status": "ERROR",
  "error": "'uniqueID'",
  "timestamp": "2026-03-25T19:14:20.328322"
}
```

---

## Statement 5: FindAllProducts

### Source Location
- **File**: app/Bookstore.Web/Controllers/ProductsController.cs
- **Method**: FindAllProducts()
- **Line**: 34

### Original MS SQL Statement
```sql
EXEC [dbo].[uspGetProductData]
```

### DMS MCP Tool Output
```json
{
  "conversion_timestamp": "2026-03-25T19:12:35.869893",
  "input": {
    "sql_text": "EXEC [dbo].[uspGetProductData]",
    "migration_project_identifier": "arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U",
    "database_name": "BobsBookstore",
    "schema_name": "dbo",
    "region": "us-east-1",
    "server_name": "172.31.82.226"
  },
  "status": "error",
  "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}\"}"
}
```

### Manual Conversion
- **Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Converted PostgreSQL Statement**:
```sql
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
```
- **Conversion Notes**: SQL Server `EXEC` stored procedure call converted to PostgreSQL function call syntax. Schema and function name lowercased.

### SQL Equivalency Tool Output
```json
{
  "equivalence_status": "ERROR",
  "error": "'uniqueID'",
  "timestamp": "2026-03-25T19:14:30.948772"
}
```

---

## Summary
- **Total Statements Processed**: 5
- **DMS Successful Conversions**: 0
- **DMS Failed Conversions**: 5 (all failed with metadata model creation error)
- **Manual Conversions Applied**: 5 (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)
- **Equivalency Validated as EQUIVALENT**: 0
- **Equivalency Validated as NOT_EQUIVALENT**: 0
- **Equivalency Validated with ERROR**: 5 (all returned 'uniqueID' error from tool)
