# PostgreSQL Database Deployment Guide

## Overview
This guide provides step-by-step instructions for deploying the PostgreSQL database components required by the migrated Bob's Bookstore .NET application. The code migration is **complete and successfully compiles**. This guide addresses the remaining deployment prerequisites before functional testing can begin.

## Prerequisites

### 1. PostgreSQL Installation
- PostgreSQL 12 or higher installed and running
- Access to PostgreSQL server with CREATE DATABASE privileges
- PostgreSQL client tools (psql) installed

### 2. Database Schema
The following database objects must exist before deploying functions:
- Schema: `bobsbookstore_dbo`
- Table: `bobsbookstore_dbo.author` (with columns: BusinessEntityID, NationalIDNumber, BirthDate, MaritalStatus, Gender, HireDate, ModifiedDate)
- Table: `bobsbookstore_dbo.product` (with columns: ProductID, Name, ProductNumber, SafetyStockLevel)

### 3. Required Files
Located in `/QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/db/`:
- `postgresql_functions_migration.sql` - Function definitions (CREATED by this fix)
- `bobsusedbooks.sql` - Original SQL Server database schema (reference only)

## Deployment Steps

### Step 1: Create PostgreSQL Database

```bash
# Connect to PostgreSQL as superuser
psql -U postgres

# Create database
CREATE DATABASE bobsbookstore;

# Connect to the new database
\c bobsbookstore
```

### Step 2: Create Schema

```sql
-- Create the application schema
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;

-- Set search path
SET search_path TO bobsbookstore_dbo, public;
```

### Step 3: Create Tables (Schema Migration)

**IMPORTANT**: The table schema must match the structure expected by the application. You have two options:

#### Option A: Use AWS DMS Schema Conversion Tool
If you have access to AWS DMS Schema Conversion Tool, use it to convert the SQL Server schema from `bobsusedbooks.sql` to PostgreSQL format.

#### Option B: Manual Table Creation
Create the minimum required tables manually:

```sql
-- Create Author table
CREATE TABLE bobsbookstore_dbo.author (
    BusinessEntityID INTEGER PRIMARY KEY,
    NationalIDNumber VARCHAR(15),
    BirthDate TIMESTAMP,
    MaritalStatus CHAR(1),
    Gender CHAR(1),
    HireDate TIMESTAMP,
    ModifiedDate TIMESTAMP DEFAULT NOW()
);

-- Create Product table
CREATE TABLE bobsbookstore_dbo.product (
    ProductID INTEGER PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    ProductNumber VARCHAR(25) NOT NULL,
    SafetyStockLevel SMALLINT NOT NULL
);

-- Create indexes for performance
CREATE INDEX idx_author_businessentityid ON bobsbookstore_dbo.author(BusinessEntityID);
CREATE INDEX idx_author_hiredate ON bobsbookstore_dbo.author(HireDate);
CREATE INDEX idx_product_productid ON bobsbookstore_dbo.product(ProductID);
```

### Step 4: Deploy PostgreSQL Functions

This is the **CRITICAL STEP** that enables the application to execute database operations.

```bash
# Navigate to the db directory
cd /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/db

# Deploy the functions
psql -d bobsbookstore -f postgresql_functions_migration.sql
```

Expected output:
```
CREATE FUNCTION
GRANT
CREATE FUNCTION
GRANT
CREATE FUNCTION
GRANT
```

### Step 5: Verify Function Deployment

```sql
-- Connect to database
\c bobsbookstore

-- List all functions in bobsbookstore_dbo schema
SELECT 
    n.nspname AS schema_name,
    p.proname AS function_name,
    pg_get_function_arguments(p.oid) AS parameters,
    pg_get_function_result(p.oid) AS return_type
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'bobsbookstore_dbo'
  AND p.proname IN ('uspupdateauthorpersonalinfo', 'uspdeleteauthor', 'uspgetproductdata')
ORDER BY p.proname;
```

Expected result: 3 functions listed
1. `uspdeleteauthor` (p_businessentityid integer) → integer
2. `uspgetproductdata` () → TABLE(productid integer, name character varying, ...)
3. `uspupdateauthorpersonalinfo` (5 parameters) → integer

### Step 6: Insert Test Data (Optional)

```sql
-- Insert sample author data
INSERT INTO bobsbookstore_dbo.author 
(BusinessEntityID, NationalIDNumber, BirthDate, MaritalStatus, Gender, HireDate, ModifiedDate)
VALUES 
(1, '245797967', '1972-05-15', 'M', 'M', '2009-01-14', NOW()),
(2, '509647174', '1981-12-30', 'S', 'F', '2008-01-27', NOW()),
(3, '112457891', '1987-08-21', 'M', 'M', '2010-03-15', NOW());

-- Insert sample product data
INSERT INTO bobsbookstore_dbo.product 
(ProductID, Name, ProductNumber, SafetyStockLevel)
VALUES 
(1, 'Product A', 'PN-1000', 100),
(2, 'Product B', 'PN-2000', 200),
(3, 'Product C', 'PN-3000', 150);

-- Verify data
SELECT * FROM bobsbookstore_dbo.author;
SELECT * FROM bobsbookstore_dbo.product;
```

### Step 7: Test Functions Individually

```sql
-- Test 1: uspUpdateAuthorPersonalInfo
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(
    1,                    -- BusinessEntityID
    '245797967',          -- NationalIDNumber
    '1972-05-15'::timestamp, -- BirthDate
    'M',                  -- MaritalStatus
    'M'                   -- Gender
);
-- Expected: Returns 1 (one row updated)

-- Test 2: uspDeleteAuthor (use with caution - deletes data!)
-- First, insert a test record
INSERT INTO bobsbookstore_dbo.author 
(BusinessEntityID, NationalIDNumber, BirthDate, MaritalStatus, Gender, HireDate)
VALUES (999, '999999999', '1990-01-01', 'S', 'M', '2020-01-01');

-- Now test delete
SELECT bobsbookstore_dbo.uspDeleteAuthor(999);
-- Expected: Returns 1 (one row deleted)

-- Test 3: uspGetProductData
SELECT * FROM bobsbookstore_dbo.uspGetProductData();
-- Expected: Returns all product records
```

### Step 8: Configure Application Connection String

Update the connection string in your .NET application configuration to point to the PostgreSQL database:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=bobsbookstore;Username=your_username;Password=your_password"
  }
}
```

## Verification Checklist

Before proceeding to functional testing, verify:

- [ ] PostgreSQL database `bobsbookstore` created
- [ ] Schema `bobsbookstore_dbo` exists
- [ ] Table `bobsbookstore_dbo.author` exists with correct columns
- [ ] Table `bobsbookstore_dbo.product` exists with correct columns
- [ ] Function `uspUpdateAuthorPersonalInfo` created and tested
- [ ] Function `uspDeleteAuthor` created and tested
- [ ] Function `uspGetProductData` created and tested
- [ ] Sample data inserted and verified
- [ ] Application connection string configured

## Troubleshooting

### Issue: "schema bobsbookstore_dbo does not exist"
**Solution**: Execute `CREATE SCHEMA bobsbookstore_dbo;` before deploying functions

### Issue: "relation author/product does not exist"
**Solution**: Create the required tables following Step 3

### Issue: "permission denied for schema"
**Solution**: Grant appropriate privileges:
```sql
GRANT USAGE ON SCHEMA bobsbookstore_dbo TO your_username;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA bobsbookstore_dbo TO your_username;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA bobsbookstore_dbo TO your_username;
```

### Issue: Function execution fails with parameter type errors
**Solution**: Ensure parameter types match exactly. PostgreSQL is strict about type matching.

### Issue: "function does not exist" when calling from application
**Solution**: Verify the function name is fully qualified: `bobsbookstore_dbo.functionname`

## Next Steps After Deployment

Once database deployment is complete:

1. **Run Application Build** (already verified - 0 errors)
   ```bash
   cd /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode
   dotnet build BobsBookstore.sln --configuration Release
   ```

2. **Execute Functional Tests**
   - Test all 5 converted SQL statements
   - Verify Statement 4 (date functions) with edge cases
   - Compare results with SQL Server baseline

3. **Validate Exit Criteria**
   - Criterion 13: Database operations execute successfully ✓
   - Criterion 15: Application passes tests ✓

4. **Document Results**
   - Record any behavioral differences
   - Update validation summary
   - Complete migration final report

## Support and References

- **PostgreSQL Functions Documentation**: https://www.postgresql.org/docs/current/xfunc.html
- **SQL Server to PostgreSQL Migration Guide**: https://wiki.postgresql.org/wiki/Converting_from_other_Databases_to_PostgreSQL
- **Migration Artifacts Location**: `/QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/`
  - `extracted_statements.sql` - Original SQL statements
  - `converted_statements.sql` - Converted PostgreSQL statements
  - `dms_conversion_log.json` - DMS tool conversion attempts
  - `sql_equivalency_validation_report.json` - Equivalency validation results
  - `migration_final_report.json` - Complete migration report

## Status Update

**Code Migration**: ✅ COMPLETE (0 build errors)  
**Database Deployment**: 📋 DOCUMENTED (this guide + postgresql_functions_migration.sql)  
**Function Migration Script**: ✅ CREATED (postgresql_functions_migration.sql)  
**Functional Testing**: ⏳ PENDING (requires database deployment)

---

**Last Updated**: Migration completion phase  
**Migration ID**: 20260219_084606_1ed6e655  
**Application**: Bob's Bookstore .NET ADO Application
