# PostgreSQL Functions Migration Guide

## Overview
This guide documents the PostgreSQL functions that must be created to support the migrated BobsBookstore application. The .NET code has been updated to call these functions, but the PostgreSQL database must have these functions implemented.

## Required PostgreSQL Functions

### 1. uspupdateauthorpersonalinfo
**Original SQL Server Stored Procedure**: `[dbo].[uspUpdateAuthorPersonalInfo]`  
**PostgreSQL Function Schema**: `bobsbookstore_dbo.uspupdateauthorpersonalinfo`  
**Called From**: `AuthorsController.cs` - `EditUsingStoredProcedure` method (line ~162)

**Expected Signature:**
```sql
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    p_businessentityid INT,
    p_nationalidnumber VARCHAR,
    p_birthdate DATE,
    p_maritalstatus CHAR(1),
    p_gender CHAR(1)
) RETURNS INT AS $$
DECLARE
    v_rows_affected INT;
BEGIN
    -- Implementation: Update author personal information
    -- Return: Number of rows affected
    UPDATE bobsbookstore_dbo.author
    SET 
        NationalIDNumber = p_nationalidnumber,
        BirthDate = p_birthdate,
        MaritalStatus = p_maritalstatus,
        Gender = p_gender,
        ModifiedDate = CURRENT_TIMESTAMP
    WHERE BusinessEntityID = p_businessentityid;
    
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    RETURN v_rows_affected;
END;
$$ LANGUAGE plpgsql;
```

**C# Code Usage:**
```csharp
var sql = "SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);";
var rowsAffected = await _context.Database.ExecuteSqlRawAsync(sql, parameters);
```

**Notes:**
- Function must return an integer (rows affected)
- Parameters must match the .NET code's NpgsqlParameter definitions
- Function must be accessible from the connection user's schema path

---

### 2. uspdeleteauthor
**Original SQL Server Stored Procedure**: `[dbo].[uspDeleteAuthor]`  
**PostgreSQL Function Schema**: `bobsbookstore_dbo.uspdeleteauthor`  
**Called From**: `AuthorsController.cs` - `DeleteAuthorEmbeddedSql` method (line ~200)

**Expected Signature:**
```sql
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspdeleteauthor(
    p_businessentityid INT
) RETURNS INT AS $$
DECLARE
    v_rows_affected INT;
BEGIN
    -- Implementation: Delete author and related records
    -- Consider cascade deletes or explicit deletion of related records
    DELETE FROM bobsbookstore_dbo.author
    WHERE BusinessEntityID = p_businessentityid;
    
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    RETURN v_rows_affected;
END;
$$ LANGUAGE plpgsql;
```

**C# Code Usage:**
```csharp
var sql = "SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);";
var rowsAffected = await _context.Database.ExecuteSqlRawAsync(sql, parameters);
```

**Notes:**
- Function must return an integer (rows affected)
- Consider foreign key constraints and cascade behavior
- May need to handle related records before deletion

---

### 3. uspgetproductdata
**Original SQL Server Stored Procedure**: `[dbo].[uspGetProductData]`  
**PostgreSQL Function Schema**: `bobsbookstore_dbo.uspgetproductdata`  
**Called From**: `ProductsController.cs` - `FindAllProducts` method (line ~31)

**Expected Signature:**
```sql
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspgetproductdata()
RETURNS TABLE (
    -- Define columns based on Product table structure
    ProductID INT,
    Name VARCHAR,
    ProductNumber VARCHAR,
    -- Add all relevant columns from Product table
    StandardCost DECIMAL,
    ListPrice DECIMAL,
    ModifiedDate TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.ProductID,
        p.Name,
        p.ProductNumber,
        p.StandardCost,
        p.ListPrice,
        p.ModifiedDate
    FROM bobsbookstore_dbo.product p
    ORDER BY p.ProductID;
END;
$$ LANGUAGE plpgsql;
```

**C# Code Usage:**
```csharp
var sql = "SELECT * FROM bobsbookstore_dbo.uspgetproductdata();";
var products = await _context.Products.FromSqlRaw(sql).ToListAsync();
```

**Notes:**
- Function must return a result set compatible with Product entity
- Ensure all columns match the C# Product class properties
- Function takes no parameters

---

## Schema Considerations

### Schema Path Configuration
The PostgreSQL connection must be configured to search the `bobsbookstore_dbo` schema:

```sql
-- Set search path for the database user
ALTER DATABASE BobsUsedBookStore SET search_path TO bobsbookstore_dbo, public;

-- Or set search path for the connection user
ALTER USER your_app_user SET search_path TO bobsbookstore_dbo, public;
```

### Schema Creation
Ensure the schema exists before creating functions:

```sql
-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;

-- Grant usage permissions
GRANT USAGE ON SCHEMA bobsbookstore_dbo TO your_app_user;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA bobsbookstore_dbo TO your_app_user;
```

---

## Original SQL Server Stored Procedures

### Reference: Original uspUpdateAuthorPersonalInfo
Located in: `db/bobsusedbooks.sql`

The original SQL Server stored procedure logic should be referenced when implementing the PostgreSQL function. Key differences to account for:
- T-SQL specific syntax → PL/pgSQL syntax
- `@@ROWCOUNT` → `GET DIAGNOSTICS ... ROW_COUNT`
- Error handling: SQL Server TRY/CATCH → PostgreSQL EXCEPTION blocks
- Output parameters: SQL Server uses OUTPUT → PostgreSQL uses RETURNS or OUT parameters

### Reference: Original uspDeleteAuthor
Located in: `db/bobsusedbooks.sql`

Review the original stored procedure for:
- Business logic (e.g., cascading deletes)
- Validation rules
- Error handling requirements
- Transaction management

### Reference: Original uspGetProductData
Located in: `db/bobsusedbooks.sql`

Review the original stored procedure for:
- Complete column list
- JOIN operations (if any)
- WHERE conditions (if any)
- ORDER BY clauses

---

## Migration Steps

### Step 1: Extract Original Stored Procedure Definitions
```bash
cd /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/db
grep -A 50 "CREATE PROCEDURE \[dbo\]\.\[uspUpdateAuthorPersonalInfo\]" bobsusedbooks.sql
grep -A 50 "CREATE PROCEDURE \[dbo\]\.\[uspDeleteAuthor\]" bobsusedbooks.sql
grep -A 50 "CREATE PROCEDURE \[dbo\]\.\[uspGetProductData\]" bobsusedbooks.sql
```

### Step 2: Convert to PostgreSQL Functions
For each stored procedure:
1. Identify input parameters and their types
2. Identify return type (scalar value, result set, or none)
3. Convert T-SQL logic to PL/pgSQL
4. Handle PostgreSQL-specific syntax differences
5. Test function independently before integrating

### Step 3: Deploy Functions to PostgreSQL
```sql
-- Connect to PostgreSQL database
psql -h your_host -p your_port -U your_user -d BobsUsedBookStore

-- Create schema
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;

-- Create functions (paste converted function definitions)
-- Function 1: uspupdateauthorpersonalinfo
-- Function 2: uspdeleteauthor
-- Function 3: uspgetproductdata

-- Verify functions exist
\df bobsbookstore_dbo.*

-- Grant permissions
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA bobsbookstore_dbo TO your_app_user;
```

### Step 4: Test Functions
```sql
-- Test uspupdateauthorpersonalinfo
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(1, 'TEST123', '1980-01-01', 'M', 'M');

-- Test uspdeleteauthor (use test data only!)
SELECT bobsbookstore_dbo.uspdeleteauthor(999);

-- Test uspgetproductdata
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
```

### Step 5: Integration Testing
Once functions are deployed:
1. Update connection string in application configuration
2. Run the .NET application
3. Test each controller action:
   - `AuthorsController.EditUsingStoredProcedure`
   - `AuthorsController.DeleteAuthorEmbeddedSql`
   - `ProductsController.FindAllProducts`
4. Verify results match expected behavior

---

## Common Conversion Patterns

### SQL Server → PostgreSQL

| SQL Server | PostgreSQL | Notes |
|------------|------------|-------|
| `@@ROWCOUNT` | `GET DIAGNOSTICS var = ROW_COUNT` | After DML statement |
| `@@ERROR` | `EXCEPTION` blocks | Error handling |
| `BEGIN...END` | `BEGIN...END` | Same syntax |
| `SET @var = value` | `var := value` | Assignment |
| `RETURN value` | `RETURN value` | Scalar return |
| `SELECT col1, col2` (result set) | `RETURNS TABLE` or `RETURNS SETOF` | Table return |
| `OUTPUT` parameter | `OUT` parameter or `RETURNS` | Output values |
| `IF EXISTS (SELECT...)` | `IF EXISTS (SELECT...)` | Same syntax |
| `RAISERROR` | `RAISE EXCEPTION` | Error raising |
| `TRY...CATCH` | `BEGIN...EXCEPTION WHEN...END` | Error handling |

---

## Validation Checklist

Before marking the migration as complete:

- [ ] All 3 PostgreSQL functions created in `bobsbookstore_dbo` schema
- [ ] Function signatures match the C# code's parameter definitions
- [ ] Functions tested independently with sample data
- [ ] Schema path configured correctly for database user
- [ ] Execute permissions granted to application user
- [ ] .NET application successfully connects to PostgreSQL
- [ ] All controller actions execute without errors
- [ ] Data returned from functions matches expected format
- [ ] Transaction behavior verified (if applicable)
- [ ] Error handling tested with invalid inputs

---

## Troubleshooting

### Function Not Found Error
```
ERROR: function bobsbookstore_dbo.uspupdateauthorpersonalinfo does not exist
```

**Solutions:**
1. Verify schema exists: `\dn` in psql
2. Verify function exists: `\df bobsbookstore_dbo.*`
3. Check search_path: `SHOW search_path;`
4. Set search_path: `SET search_path TO bobsbookstore_dbo, public;`

### Permission Denied Error
```
ERROR: permission denied for function uspupdateauthorpersonalinfo
```

**Solutions:**
1. Grant execute permission: `GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo TO your_user;`
2. Grant schema usage: `GRANT USAGE ON SCHEMA bobsbookstore_dbo TO your_user;`

### Parameter Type Mismatch
```
ERROR: function uspupdateauthorpersonalinfo(integer, text, date, character, character) does not exist
```

**Solutions:**
1. Verify parameter types in function definition match C# code
2. Add explicit type casts in SQL: `::INTEGER`, `::VARCHAR`
3. Use function overloading if needed

### Return Type Mismatch
```
ERROR: return type mismatch in function declared to return integer
```

**Solutions:**
1. Ensure `RETURNS` clause matches actual return statement
2. For table results, use `RETURNS TABLE(...)` or `RETURNS SETOF type`
3. Verify all code paths return appropriate value

---

## Additional Resources

### PostgreSQL Documentation
- PL/pgSQL Functions: https://www.postgresql.org/docs/current/plpgsql.html
- Function Creation: https://www.postgresql.org/docs/current/sql-createfunction.html
- Error Handling: https://www.postgresql.org/docs/current/plpgsql-control-structures.html#PLPGSQL-ERROR-TRAPPING

### SQL Server to PostgreSQL Migration
- Data Type Mapping: https://wiki.postgresql.org/wiki/SQL_Server_to_PostgreSQL_Migration
- Function Conversion: https://www.postgresql.org/docs/current/plpgsql-porting.html

---

## Contact and Support

For issues related to:
- **Function logic**: Review original SQL Server stored procedures in `db/bobsusedbooks.sql`
- **PostgreSQL syntax**: Consult PostgreSQL documentation or DBA
- **C# integration**: Review controller code in `app/Bookstore.Web/Controllers/`
- **Build errors**: Check `build.log` for details

---

**Document Version**: 1.0  
**Last Updated**: 2026-02-19  
**Migration Phase**: PostgreSQL Functions Deployment Required
