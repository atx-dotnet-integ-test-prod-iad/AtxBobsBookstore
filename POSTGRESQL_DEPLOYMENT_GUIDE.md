# PostgreSQL Deployment Guide for BobsBookstore

## Overview
This guide provides step-by-step instructions for deploying the required PostgreSQL database schema and functions to complete the SQL Server to PostgreSQL migration for the BobsBookstore application.

## Prerequisites
- PostgreSQL 12 or higher installed and running
- Database user with CREATE FUNCTION and CREATE TABLE privileges
- Access to AWS Secrets Manager (or ability to configure connection strings)
- All code transformations completed (verified by successful build)

## Deployment Steps

### Step 1: Create Database and Schema

```sql
-- Create the database if it doesn't exist
CREATE DATABASE bobsbookstore;

-- Connect to the database
\c bobsbookstore

-- Create the schema
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;

-- Set the search path
SET search_path TO bobsbookstore_dbo, public;
```

### Step 2: Create Required Tables

Based on the converted SQL statements, the following tables are referenced:

```sql
-- Author table (referenced in multiple queries)
CREATE TABLE IF NOT EXISTS bobsbookstore_dbo.author (
    BusinessEntityID INT PRIMARY KEY,
    NationalIDNumber VARCHAR(50),
    BirthDate DATE,
    MaritalStatus CHAR(1),
    Gender CHAR(1),
    HireDate DATE,
    ModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product table (referenced in uspGetProductData)
-- Note: Adjust columns based on actual requirements
CREATE TABLE IF NOT EXISTS bobsbookstore_dbo.product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    ProductNumber VARCHAR(50),
    -- Add additional columns as needed
    ModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Step 3: Create Required PostgreSQL Functions

#### Function 1: uspupdateauthorpersonalinfo

This function replaces the SQL Server stored procedure `uspUpdateAuthorPersonalInfo`.

```sql
-- Drop function if exists (for redeployment)
DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspupdateauthorpersonalinfo(INT, VARCHAR, DATE, CHAR, CHAR);

-- Create function
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    p_businessentityid INT,
    p_nationalidnumber VARCHAR,
    p_birthdate DATE,
    p_maritalstatus CHAR,
    p_gender CHAR
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INT;
BEGIN
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
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo(INT, VARCHAR, DATE, CHAR, CHAR) TO PUBLIC;
```

#### Function 2: uspdeleteauthor

This function replaces the SQL Server stored procedure `uspDeleteAuthor`.

```sql
-- Drop function if exists (for redeployment)
DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspdeleteauthor(INT);

-- Create function
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspdeleteauthor(
    p_businessentityid INT
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INT;
BEGIN
    -- Delete the author record
    DELETE FROM bobsbookstore_dbo.author
    WHERE BusinessEntityID = p_businessentityid;
    
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    RETURN v_rows_affected;
    
    -- Note: If there are foreign key constraints, you may need to:
    -- 1. Set ON DELETE CASCADE on foreign keys, OR
    -- 2. Delete related records first, OR
    -- 3. Handle exceptions appropriately
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspdeleteauthor(INT) TO PUBLIC;
```

#### Function 3: uspgetproductdata

This function replaces the SQL Server stored procedure `uspGetProductData`.

```sql
-- Drop function if exists (for redeployment)
DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspgetproductdata();

-- Create function that returns a table
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspgetproductdata()
RETURNS TABLE (
    ProductID INT,
    ProductName VARCHAR,
    ProductNumber VARCHAR,
    -- Add additional columns based on actual requirements
    ModifiedDate TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.ProductID,
        p.ProductName,
        p.ProductNumber,
        -- Add additional columns
        p.ModifiedDate
    FROM bobsbookstore_dbo.product p
    ORDER BY p.ProductID;
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspgetproductdata() TO PUBLIC;
```

### Step 4: Verify Function Creation

Run the following queries to verify all functions were created successfully:

```sql
-- List all functions in the schema
SELECT 
    routine_name,
    routine_type,
    data_type as return_type
FROM information_schema.routines
WHERE routine_schema = 'bobsbookstore_dbo'
ORDER BY routine_name;

-- Expected output should show:
-- uspdeleteauthor          | FUNCTION | integer
-- uspgetproductdata        | FUNCTION | SETOF record
-- uspupdateauthorpersonalinfo | FUNCTION | integer
```

### Step 5: Test Functions Individually

Before running the full application, test each function:

```sql
-- Test 1: Insert test data
INSERT INTO bobsbookstore_dbo.author (BusinessEntityID, NationalIDNumber, BirthDate, MaritalStatus, Gender, HireDate)
VALUES (1, 'TEST123', '1980-01-01', 'S', 'M', '2020-01-01');

-- Test 2: Test uspupdateauthorpersonalinfo
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(1, 'TEST456', '1985-06-15', 'M', 'F');
-- Should return: 1 (one row affected)

-- Test 3: Verify update
SELECT * FROM bobsbookstore_dbo.author WHERE BusinessEntityID = 1;
-- Should show updated values

-- Test 4: Test uspgetproductdata
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
-- Should return product records (may be empty if no data)

-- Test 5: Test uspdeleteauthor
SELECT bobsbookstore_dbo.uspdeleteauthor(1);
-- Should return: 1 (one row deleted)

-- Test 6: Verify deletion
SELECT * FROM bobsbookstore_dbo.author WHERE BusinessEntityID = 1;
-- Should return no rows
```

### Step 6: Configure AWS Secrets Manager

Update the AWS Secrets Manager secret with PostgreSQL connection details:

```json
{
  "username": "your_postgres_user",
  "password": "your_postgres_password",
  "engine": "postgres",
  "host": "your-postgres-host.amazonaws.com",
  "port": 5432,
  "dbname": "bobsbookstore"
}
```

Secret ARN (from migration_summary.txt):
```
arn:aws:secretsmanager:us-east-1:789616364195:secret:atx-db-modernization-jaabou-DBConnector-setup-bobsBookStoreDB-source-target-ExUSmt
```

### Step 7: Application Connection String Verification

The application retrieves the connection string from AWS Secrets Manager in `ServicesSetup.cs`:

```csharp
// Connection is built using NpgsqlConnectionStringBuilder
var builder = new NpgsqlConnectionStringBuilder
{
    Host = secret["host"],
    Port = int.Parse(secret["port"]),
    Database = secret["dbname"],
    Username = secret["username"],
    Password = secret["password"]
};
```

Verify the secret contains all required fields.

### Step 8: Run Application and Test

1. **Build the application:**
   ```bash
   cd /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode
   dotnet build
   ```

2. **Run the application:**
   ```bash
   dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
   ```

3. **Test each endpoint:**
   - GET /Authors/FindAllAuthorsEmbeddedSql - Should return all authors
   - POST /Authors/EditUsingStoredProcedure - Should update author info
   - DELETE /Authors/DeleteAuthorEmbeddedSql - Should delete author
   - GET /Authors/SelectAuthorsByHireYear?hireYear=2020 - Should filter by hire year
   - GET /Products/FindAllProducts - Should return all products

### Step 9: Validate SQL Statement Equivalency Through Runtime Testing

The SQL Equivalency tool marked 4 statements with ERROR (UNKNOWN) status. These require manual validation:

#### Statement 1 - EditUsingStoredProcedure
**Manual Test:**
1. Insert a test author record
2. Call the EditUsingStoredProcedure endpoint with updated values
3. Verify:
   - Function returns rows_affected = 1
   - Database record is updated correctly
   - All parameter values are applied

#### Statement 3 - DeleteAuthorEmbeddedSql
**Manual Test:**
1. Insert a test author record
2. Call the DeleteAuthorEmbeddedSql endpoint
3. Verify:
   - Function returns rows_affected = 1
   - Database record is deleted
   - No orphaned foreign key references

#### Statement 4 - SelectAuthorsByHireYear
**Manual Test:**
1. Insert test authors with known hire years and birth dates
2. Call SelectAuthorsByHireYear with a specific year
3. Verify:
   - Only authors hired in that year are returned
   - FormattedModifiedDate matches expected format: 'YYYY-MM-DD HH24:MI:SS'
   - Age calculation matches: DATE_PART('year', AGE(CURRENT_DATE, BirthDate))
   - Compare results with SQL Server version if available

#### Statement 5 - FindAllProducts
**Manual Test:**
1. Insert test product records
2. Call FindAllProducts endpoint
3. Verify:
   - All products are returned
   - Column structure matches expectations
   - Data types are correct

### Step 10: Performance Testing (Optional)

Compare query performance between SQL Server and PostgreSQL:

```sql
-- Enable query timing
\timing on

-- Test query performance
EXPLAIN ANALYZE SELECT * FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = 2020;

-- Compare execution plans and timing
```

## Troubleshooting

### Issue: Function not found
**Error:** `function bobsbookstore_dbo.uspupdateauthorpersonalinfo does not exist`

**Solution:**
- Verify schema exists: `SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'bobsbookstore_dbo';`
- Verify function exists: `\df bobsbookstore_dbo.*`
- Check search_path: `SHOW search_path;`

### Issue: Parameter type mismatch
**Error:** `function ... does not exist ... HINT: No function matches the given name and argument types`

**Solution:**
- Verify parameter types in function definition match application code
- Check NpgsqlParameter DbType mappings in controller code
- Use explicit type casting if needed: `functionname($1::int, $2::varchar)`

### Issue: Connection failed
**Error:** `Npgsql.NpgsqlException: Connection refused`

**Solution:**
- Verify PostgreSQL is running: `pg_isready -h localhost -p 5432`
- Check pg_hba.conf for authentication configuration
- Verify AWS Secrets Manager secret is correctly configured
- Check network connectivity if database is remote

### Issue: Date/time function results differ
**Error:** Age or date calculations return different values

**Solution:**
- SQL Server `DATEDIFF(YEAR, date1, date2)` vs PostgreSQL `DATE_PART('year', AGE(date2, date1))`
- Verify parameter order: AGE takes (end_date, start_date)
- Test with known values to confirm accuracy

## Migration Validation Checklist

- [ ] PostgreSQL database created
- [ ] Schema `bobsbookstore_dbo` created
- [ ] All required tables created
- [ ] Function `uspupdateauthorpersonalinfo` created and tested
- [ ] Function `uspdeleteauthor` created and tested
- [ ] Function `uspgetproductdata` created and tested
- [ ] AWS Secrets Manager configured with PostgreSQL credentials
- [ ] Application builds successfully (0 errors)
- [ ] Application connects to PostgreSQL database
- [ ] All 5 SQL statements execute successfully
- [ ] Manual validation completed for 4 statements with ERROR equivalency status
- [ ] CRUD operations tested (Create, Read, Update, Delete)
- [ ] Date/time functions produce expected results
- [ ] Transaction atomicity verified
- [ ] Performance acceptable compared to SQL Server baseline

## Additional Notes

### Schema Object Naming Conventions
- SQL Server uses case-insensitive identifiers
- PostgreSQL converts unquoted identifiers to lowercase
- All function names are lowercase: `uspupdateauthorpersonalinfo` not `uspUpdateAuthorPersonalInfo`
- Schema-qualified names required: `bobsbookstore_dbo.functionname`

### Parameter Naming
- SQL Server uses `@paramname` syntax
- PostgreSQL uses positional `$1, $2` or named parameters
- Npgsql handles `@paramname` syntax automatically in parameterized queries

### Return Value Handling
- SQL Server: `EXEC @returnValue = procedurename`
- PostgreSQL: `SELECT functionname() AS return_value`

## Support and References

- **Migration Summary:** See `migration_summary.txt` for complete transformation details
- **SQL Conversion Log:** See `converted_statements.sql` for all SQL transformations
- **Equivalency Report:** See `sql_equivalency_validation_report.json` for validation results
- **Npgsql Documentation:** https://www.npgsql.org/doc/
- **PostgreSQL Documentation:** https://www.postgresql.org/docs/

## Completion Criteria

This deployment is complete when:
1. All functions are created and tested individually
2. Application successfully connects to PostgreSQL
3. All 5 SQL statements execute without errors
4. Manual testing confirms functional equivalency for the 4 statements marked with ERROR
5. All CRUD operations work as expected
6. No data loss or corruption occurs during operations
7. Performance meets or exceeds SQL Server baseline

---
**Document Version:** 1.0  
**Last Updated:** 2026-02-03  
**Generated by:** AWS Transform CLI General Purpose Agent
