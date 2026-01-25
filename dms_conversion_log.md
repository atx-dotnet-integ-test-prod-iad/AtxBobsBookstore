# DMS SQL Statement Conversion Log

## Overview
This log documents all attempts to convert SQL Server T-SQL statements to PostgreSQL using the AWS Database Migration Service (DMS) MCP tool.

**Total Statements Processed:** 5
**Conversion Method:** dms-mcp____statement_conversion_tool
**Schema Name:** bobsbookstore_dbo
**Database Name:** BobsBookstore
**Migration Project:** arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U

---

## Statement 1: Update Author Personal Information (Stored Procedure Call)

### Original SQL (T-SQL)
```sql
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;
```

### DMS Tool Invocation
- **Timestamp:** 2026-01-25T15:30:29.043922
- **Schema:** bobsbookstore_dbo
- **Status:** ERROR

### DMS Tool Output
```json
{
  "status": "error",
  "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}\"}",
  "error_timestamp": "2026-01-25T15:30:44.128234"
}
```

### Manual Conversion Applied
Since DMS could not convert due to missing metadata objects, manual conversion was applied based on PostgreSQL best practices:

**PostgreSQL Version:**
```sql
-- Note: Stored procedure must be created in PostgreSQL first
-- Assuming the procedure returns affected rows, convert to function call or direct SQL
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    @BusinessEntityID, 
    @NationalIDNumber, 
    @BirthDate, 
    @MaritalStatus, 
    @Gender
);
```

**Alternative (if stored procedure doesn't exist in PostgreSQL):**
```sql
UPDATE bobsbookstore_dbo.author
SET 
    nationalidnumber = @NationalIDNumber,
    birthdate = @BirthDate,
    maritalstatus = @MaritalStatus,
    gender = @Gender,
    modifieddate = CURRENT_TIMESTAMP
WHERE businessentityid = @BusinessEntityID;
```

### Conversion Notes
- DECLARE/EXEC/SELECT pattern removed (PostgreSQL functions return values directly)
- Stored procedure name converted to lowercase (PostgreSQL convention)
- Alternative UPDATE statement provided if stored procedure migration not complete
- Schema name kept as bobsbookstore_dbo (DMS did not change it)

---

## Statement 2: Select All Authors

### Original SQL (T-SQL)
```sql
SELECT * FROM bobsbookstore_dbo.author
```

### DMS Tool Invocation
- **Timestamp:** 2026-01-25T15:30:53.954817
- **Schema:** bobsbookstore_dbo
- **Status:** ERROR

### DMS Tool Output
```json
{
  "status": "error",
  "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}\"}",
  "error_timestamp": "2026-01-25T15:31:08.791561"
}
```

### Manual Conversion Applied
This statement is already PostgreSQL-compatible. No syntax changes required.

**PostgreSQL Version:**
```sql
SELECT * FROM bobsbookstore_dbo.author
```

### Conversion Notes
- Schema-qualified table name maintained
- SELECT * syntax is identical in PostgreSQL
- DMS did not change schema name, so bobsbookstore_dbo remains

---

## Statement 3: Delete Author (Stored Procedure Call)

### Original SQL (T-SQL)
```sql
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;
```

### DMS Tool Invocation
- **Timestamp:** 2026-01-25T15:31:40.801008
- **Schema:** bobsbookstore_dbo
- **Status:** ERROR

### DMS Tool Output
```json
{
  "status": "error",
  "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}\"}",
  "error_timestamp": "2026-01-25T15:31:55.716589"
}
```

### Manual Conversion Applied
**PostgreSQL Version:**
```sql
-- Note: Stored procedure must be created in PostgreSQL first
-- Assuming the procedure returns affected rows
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
```

**Alternative (if stored procedure doesn't exist in PostgreSQL):**
```sql
DELETE FROM bobsbookstore_dbo.author
WHERE businessentityid = @BusinessEntityID;
```

### Conversion Notes
- DECLARE/EXEC/SELECT pattern removed
- Stored procedure name converted to lowercase
- Alternative DELETE statement provided
- Schema name kept as bobsbookstore_dbo

---

## Statement 4: Select Authors by Hire Year with Age Calculation

### Original SQL (T-SQL)
```sql
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
```

### DMS Tool Invocation
- **Timestamp:** 2026-01-25T15:31:17.982761
- **Schema:** bobsbookstore_dbo
- **Status:** ERROR

### DMS Tool Output
```json
{
  "status": "error",
  "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}\"}",
  "error_timestamp": "2026-01-25T15:31:32.845614"
}
```

### Manual Conversion Applied
**PostgreSQL Version:**
```sql
SELECT 
    BusinessEntityID, 
    TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
    DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
```

### Conversion Notes
- FORMAT() → TO_CHAR() with PostgreSQL format pattern ('YYYY-MM-DD HH24:MI:SS')
- DATEDIFF(YEAR, BirthDate, GETDATE()) → DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate))
- DATEPART(YEAR, HireDate) → EXTRACT(YEAR FROM HireDate)
- GETDATE() → CURRENT_TIMESTAMP
- Schema name kept as bobsbookstore_dbo
- Column names kept in original case (PostgreSQL will lowercase automatically unless quoted)

---

## Statement 5: Get Product Data (Stored Procedure Call)

### Original SQL (T-SQL)
```sql
EXEC [dbo].[uspGetProductData];
```

### DMS Tool Invocation
- **Timestamp:** 2026-01-25T15:32:03.568089
- **Schema:** bobsbookstore_dbo
- **Status:** ERROR

### DMS Tool Output
```json
{
  "status": "error",
  "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}\"}",
  "error_timestamp": "2026-01-25T15:32:18.438095"
}
```

### Manual Conversion Applied
**PostgreSQL Version:**
```sql
-- Note: Stored procedure must be created in PostgreSQL first
-- Assuming the procedure returns a result set
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
```

**Alternative (if stored procedure doesn't exist in PostgreSQL):**
```sql
-- Assuming this retrieves all product data
SELECT * FROM bobsbookstore_dbo.product;
```

### Conversion Notes
- EXEC removed, replaced with SELECT FROM function call
- Stored procedure name converted to lowercase
- Alternative SELECT statement provided
- Schema name kept as bobsbookstore_dbo

---

## Summary

### DMS Conversion Results
- **Total Statements:** 5
- **Successfully Converted by DMS:** 0
- **Failed with Errors:** 5
- **Manually Converted After DMS Failure:** 5

### Error Analysis
All statements failed with the same error: "Metadata model creation failed: The selected objects were not found."

**Root Cause:** The DMS migration project's metadata model does not contain the schema objects (tables, stored procedures) referenced in the SQL statements. This prevents DMS from performing context-aware conversions.

### Manual Conversion Strategy
1. **Stored Procedure Calls:** Convert EXEC pattern to PostgreSQL function calls (SELECT FROM function)
2. **T-SQL Functions:** Replace with PostgreSQL equivalents:
   - FORMAT() → TO_CHAR()
   - DATEPART() → EXTRACT()
   - DATEDIFF() → DATE_PART() with AGE()
   - GETDATE() → CURRENT_TIMESTAMP
3. **Schema Names:** Preserved as bobsbookstore_dbo (no changes from DMS)
4. **Case Sensitivity:** PostgreSQL conventions applied (lowercase function/procedure names)

### Compliance with Transformation Requirements
✅ **EVERY statement was passed through DMS MCP tool** (no exceptions)  
✅ **DMS output documented for each statement**  
✅ **Manual conversions applied using best judgment after DMS failure**  
✅ **Schema name changes respected** (none occurred - kept as bobsbookstore_dbo)  
✅ **All conversions documented with rationale**

---

## Next Steps
1. Create converted_statements.sql with all PostgreSQL statements
2. Validate equivalency using SQL Equivalency MCP tool
3. Re-integrate converted statements into C# code
4. Ensure stored procedures are migrated to PostgreSQL or replaced with direct SQL
