# PostgreSQL Migration Deployment Guide
## BobsBookstore - SQL Server to PostgreSQL Migration

**Document Version:** 1.0  
**Last Updated:** 2026-01-22  
**Migration Status:** Code Transformation Complete - Awaiting Database Deployment

---

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Deployment Steps](#deployment-steps)
4. [Testing and Validation](#testing-and-validation)
5. [Rollback Procedures](#rollback-procedures)
6. [Troubleshooting](#troubleshooting)

---

## Overview

This guide provides step-by-step instructions for deploying the PostgreSQL database components required to complete the BobsBookstore migration from Microsoft SQL Server to PostgreSQL.

### Migration Accomplishments

✅ **COMPLETED:**
- All SQL statements converted using DMS MCP tool
- All SQL Server packages replaced with Npgsql equivalents
- All ADO.NET classes updated to use Npgsql
- Connection strings converted to PostgreSQL format
- Application compiles successfully with zero errors
- All equivalency validations performed using SQL Equivalency tool

⚠️ **PENDING:**
- PostgreSQL database instance deployment
- Schema and table migration
- Stored procedure deployment
- AWS SQLServer Extension installation
- Runtime testing and validation

---

## Prerequisites

### 1. Infrastructure Requirements

#### PostgreSQL Database Instance
- **Version:** PostgreSQL 12.0 or higher (recommended: 14.x or 15.x)
- **Minimum Resources:**
  - CPU: 2 vCPUs
  - RAM: 4 GB
  - Storage: 20 GB (adjust based on data size)
- **Network Access:** Application must be able to connect to PostgreSQL on port 5432

#### AWS Deployment (if using RDS)
```bash
# Example AWS CLI command to create RDS PostgreSQL instance
aws rds create-db-instance \
    --db-instance-identifier bobsbookstore-postgres \
    --db-instance-class db.t3.medium \
    --engine postgres \
    --engine-version 15.3 \
    --master-username postgres \
    --master-user-password <secure-password> \
    --allocated-storage 20 \
    --vpc-security-group-ids <security-group-id> \
    --db-subnet-group-name <subnet-group-name> \
    --backup-retention-period 7 \
    --preferred-backup-window "03:00-04:00" \
    --preferred-maintenance-window "mon:04:00-mon:05:00" \
    --publicly-accessible false \
    --storage-encrypted \
    --storage-type gp3
```

### 2. Database Schema Migration

The original SQL Server schema must be migrated to PostgreSQL. You have two options:

#### Option A: AWS Schema Conversion Tool (SCT)
1. Download and install AWS SCT
2. Create a new project for SQL Server to PostgreSQL conversion
3. Connect to source SQL Server database
4. Connect to target PostgreSQL database
5. Run schema assessment and conversion
6. Review and apply converted schema

#### Option B: AWS DMS with Schema Conversion
1. Use the same DMS project used for SQL statement conversion
2. Run full schema conversion
3. Review conversion report
4. Apply schema to PostgreSQL database

### 3. Required PostgreSQL Extensions

```sql
-- Connect to your PostgreSQL database
\c BobsUsedBookStore

-- Install required extensions
CREATE EXTENSION IF NOT EXISTS aws_sqlserver_ext;
CREATE EXTENSION IF NOT EXISTS plpgsql;  -- Usually installed by default

-- Verify extensions
SELECT * FROM pg_extension WHERE extname IN ('aws_sqlserver_ext', 'plpgsql');
```

**Note:** The `aws_sqlserver_ext` extension is CRITICAL for Statement 4 (complex query with DATEDIFF function).

### 4. Tools Required

- **psql** command-line tool (included with PostgreSQL)
- **pgAdmin** (optional, for GUI management)
- **AWS CLI** (if using AWS RDS)
- **.NET SDK** 6.0 or higher (for application testing)

---

## Deployment Steps

### Step 1: Verify Database Connection

```bash
# Test connection to PostgreSQL instance
psql -h <your-postgres-host> -U postgres -d postgres -c "SELECT version();"

# Expected output: PostgreSQL version information
```

### Step 2: Create Database and Schema

```sql
-- Connect as superuser
psql -h <host> -U postgres

-- Create database (if not exists)
CREATE DATABASE "BobsUsedBookStore"
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE = template0;

-- Connect to the new database
\c BobsUsedBookStore

-- Create schema
CREATE SCHEMA IF NOT EXISTS bobsusedbookstore_dbo;

-- Verify schema creation
SELECT schema_name FROM information_schema.schemata 
WHERE schema_name = 'bobsusedbookstore_dbo';
```

### Step 3: Migrate Schema Objects

**If using AWS SCT or DMS:**
```bash
# Follow the schema conversion tool's instructions to apply schema
# This should create all tables, indexes, constraints, etc.
```

**Manual Verification After Schema Migration:**
```sql
-- List all tables in the schema
SELECT table_schema, table_name 
FROM information_schema.tables 
WHERE table_schema = 'bobsusedbookstore_dbo'
ORDER BY table_name;

-- Verify the author table exists (required by application)
\d bobsusedbookstore_dbo.author

-- Expected columns: businessentityid, nationalidnumber, birthdate, 
--                   maritalstatus, gender, modifieddate, hiredate, etc.
```

### Step 4: Install AWS SQL Server Extensions

```sql
-- Connect to BobsUsedBookStore database
\c BobsUsedBookStore

-- Install extension (requires superuser privileges)
CREATE EXTENSION IF NOT EXISTS aws_sqlserver_ext;

-- Verify installation
SELECT * FROM pg_available_extensions 
WHERE name = 'aws_sqlserver_ext';

-- Test the DATEDIFF function (required for Statement 4)
SELECT aws_sqlserver_ext.datediff(
    'YEAR', 
    '1980-01-15'::TIMESTAMP, 
    CURRENT_TIMESTAMP::TIMESTAMP
) AS age_test;

-- Expected: Should return a number (years between dates)
```

### Step 5: Deploy Stored Procedures

```bash
# Deploy stored procedures from the included SQL file
psql -h <host> -U postgres -d BobsUsedBookStore \
     -f /path/to/postgresql_stored_procedures.sql

# Verify deployment
psql -h <host> -U postgres -d BobsUsedBookStore -c "
SELECT routine_schema, routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'bobsusedbookstore_dbo'
    AND routine_type = 'PROCEDURE'
ORDER BY routine_name;
"
```

**Expected Output:**
```
      routine_schema      |         routine_name          | routine_type 
--------------------------+-------------------------------+--------------
 bobsusedbookstore_dbo    | uspdeleteauthor              | PROCEDURE
 bobsusedbookstore_dbo    | uspupdateauthorpersonalinfo  | PROCEDURE
(2 rows)
```

### Step 6: Migrate Data

**If using AWS DMS for data migration:**
```bash
# Create DMS replication instance (if not exists)
aws dms create-replication-instance \
    --replication-instance-identifier bobsbookstore-replication \
    --replication-instance-class dms.t3.medium \
    --allocated-storage 50

# Create source endpoint (SQL Server)
aws dms create-endpoint \
    --endpoint-identifier sqlserver-source \
    --endpoint-type source \
    --engine-name sqlserver \
    --server-name <sql-server-host> \
    --port 1433 \
    --database-name BobsUsedBookStore \
    --username <username> \
    --password <password>

# Create target endpoint (PostgreSQL)
aws dms create-endpoint \
    --endpoint-identifier postgres-target \
    --endpoint-type target \
    --engine-name postgres \
    --server-name <postgres-host> \
    --port 5432 \
    --database-name BobsUsedBookStore \
    --username postgres \
    --password <password>

# Create and start migration task
# (Follow AWS DMS documentation for full task configuration)
```

### Step 7: Configure Application Connection

**Update Environment Variables or Configuration:**

```bash
# Set environment variables for the application
export DB_HOST=<your-postgres-host>
export DB_PORT=5432
export DB_NAME=BobsUsedBookStore
export DB_USERNAME=<application-user>
export DB_PASSWORD=<secure-password>
```

**OR update appsettings.json:**

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=<your-postgres-host>;Port=5432;Database=BobsUsedBookStore;Username=<app-user>;Password=<password>"
  }
}
```

### Step 8: Create Application Database User

```sql
-- Connect as superuser
\c BobsUsedBookStore

-- Create application user (if not exists)
CREATE USER bookstore_app WITH PASSWORD '<secure-password>';

-- Grant schema usage
GRANT USAGE ON SCHEMA bobsusedbookstore_dbo TO bookstore_app;

-- Grant table permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA bobsusedbookstore_dbo TO bookstore_app;

-- Grant sequence permissions (for auto-increment columns)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA bobsusedbookstore_dbo TO bookstore_app;

-- Grant execute on stored procedures
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA bobsusedbookstore_dbo TO bookstore_app;

-- Set default privileges for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA bobsusedbookstore_dbo 
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO bookstore_app;
    
ALTER DEFAULT PRIVILEGES IN SCHEMA bobsusedbookstore_dbo 
    GRANT USAGE, SELECT ON SEQUENCES TO bookstore_app;
    
ALTER DEFAULT PRIVILEGES IN SCHEMA bobsusedbookstore_dbo 
    GRANT EXECUTE ON PROCEDURES TO bookstore_app;
```

---

## Testing and Validation

### Phase 1: Database-Level Testing

#### Test 1: Verify Schema Objects
```sql
-- Count tables
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'bobsusedbookstore_dbo';

-- Count stored procedures
SELECT COUNT(*) FROM information_schema.routines 
WHERE routine_schema = 'bobsusedbookstore_dbo' 
    AND routine_type = 'PROCEDURE';

-- Verify author table structure
\d+ bobsusedbookstore_dbo.author
```

#### Test 2: Test Stored Procedures

```sql
-- Test uspupdateauthorpersonalinfo (use test data)
-- IMPORTANT: Adjust BusinessEntityID to match test data in your database

BEGIN;
    -- Insert test author if needed
    INSERT INTO bobsusedbookstore_dbo.author 
        (businessentityid, nationalidnumber, birthdate, maritalstatus, gender, modifieddate)
    VALUES 
        (99999, 'TEST123', '1980-01-15', 'S', 'M', CURRENT_TIMESTAMP);
    
    -- Test update procedure
    CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(
        99999,           -- businessentityid
        'UPDATED456',    -- nationalidnumber
        '1985-05-20'::TIMESTAMP,  -- birthdate
        'M',             -- maritalstatus
        'M'              -- gender
    );
    
    -- Verify update
    SELECT * FROM bobsusedbookstore_dbo.author WHERE businessentityid = 99999;
    
    -- Test delete procedure
    CALL bobsusedbookstore_dbo.uspdeleteauthor(99999);
    
    -- Verify deletion
    SELECT * FROM bobsusedbookstore_dbo.author WHERE businessentityid = 99999;
    -- Should return 0 rows
    
ROLLBACK;  -- Rollback test changes
```

#### Test 3: Test Complex Query (Statement 4)

```sql
-- Test the complex query with T-SQL function conversions
-- This tests: to_char, aws_sqlserver_ext.datediff, date_part, clock_timestamp

-- Sample query (adjust based on your data)
SELECT 
    businessentityid,
    to_char(modifieddate, 'yyyy-MM-dd HH:mm:ss') AS formattedmodifieddate,
    aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age
FROM bobsusedbookstore_dbo.author
WHERE date_part('year', hiredate) = 2020
LIMIT 10;

-- Verify results make sense:
-- - formattedmodifieddate should be in 'yyyy-MM-dd HH:mm:ss' format
-- - age should be a reasonable number (e.g., 20-80)
```

### Phase 2: Application-Level Testing

#### Test 1: Build and Run Application

```bash
# Navigate to application directory
cd /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode

# Clean and rebuild
dotnet clean BobsBookstore.sln
dotnet build BobsBookstore.sln

# Run application
cd app/Bookstore.Web
dotnet run

# Expected: Application should start without errors
# Watch for any connection or database errors in the logs
```

#### Test 2: Test Database Connection

```bash
# Create a simple connection test (if not already exists)
# Or test through the application's health check endpoint

curl http://localhost:5000/health
# Should return healthy status
```

#### Test 3: Test Application Features

**Test Scenario 1: Simple SELECT (Statement 1)**
- Navigate to the authors list page
- Action: View all authors
- Expected: Authors list should display without errors
- Validates: Simple SELECT statement conversion

**Test Scenario 2: Update Stored Procedure (Statement 2)**
- Navigate to edit author page
- Action: Update author personal information
- Expected: Update should succeed, data should persist
- Validates: uspUpdateAuthorPersonalInfo stored procedure

**Test Scenario 3: Delete Stored Procedure (Statement 3)**
- Navigate to delete author page
- Action: Delete an author
- Expected: Delete should succeed, author should be removed
- Validates: uspDeleteAuthor stored procedure

**Test Scenario 4: Complex Query (Statement 4)**
- Navigate to search/filter authors page
- Action: Filter authors by hire year
- Expected: Filtered results should display correctly
- Validates: Complex query with T-SQL function conversions

### Phase 3: Performance Testing

```sql
-- Compare query execution times

-- Test 1: Simple SELECT
EXPLAIN ANALYZE
SELECT * FROM bobsusedbookstore_dbo.author;

-- Test 2: Complex query
EXPLAIN ANALYZE
SELECT 
    businessentityid,
    to_char(modifieddate, 'yyyy-MM-dd HH:mm:ss') AS formattedmodifieddate,
    aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age
FROM bobsusedbookstore_dbo.author
WHERE date_part('year', hiredate) = 2020;

-- Document execution times and compare with SQL Server baseline if available
```

### Phase 4: Integration Testing

**Create Integration Test Suite:**

```bash
# Create test project (if not exists)
cd /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode

dotnet new xunit -o tests/Bookstore.IntegrationTests
cd tests/Bookstore.IntegrationTests

# Add necessary packages
dotnet add package Npgsql
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL
dotnet add package Microsoft.AspNetCore.Mvc.Testing

# Create integration tests for each SQL statement
# (See template below)
```

**Integration Test Template:**

```csharp
using Xunit;
using Npgsql;
using System;

namespace Bookstore.IntegrationTests
{
    public class PostgreSqlMigrationTests : IDisposable
    {
        private readonly NpgsqlConnection _connection;

        public PostgreSqlMigrationTests()
        {
            var connectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING") 
                ?? "Host=localhost;Port=5432;Database=BobsUsedBookStore;Username=bookstore_app;Password=test";
            _connection = new NpgsqlConnection(connectionString);
            _connection.Open();
        }

        [Fact]
        public async Task Statement1_SimpleSelect_ReturnsResults()
        {
            // Test Statement 1: Simple SELECT from Author table
            using var cmd = new NpgsqlCommand(
                "SELECT * FROM bobsusedbookstore_dbo.author LIMIT 1", 
                _connection);
            
            using var reader = await cmd.ExecuteReaderAsync();
            Assert.True(await reader.ReadAsync(), "Should return at least one author");
        }

        [Fact]
        public async Task Statement2_UpdateStoredProcedure_UpdatesAuthor()
        {
            // Test Statement 2: uspUpdateAuthorPersonalInfo
            // Create test author first
            var testId = 999999;
            
            // Insert test data
            using (var insertCmd = new NpgsqlCommand(
                @"INSERT INTO bobsusedbookstore_dbo.author 
                  (businessentityid, nationalidnumber, birthdate, maritalstatus, gender, modifieddate)
                  VALUES (@id, @nid, @bd, @ms, @g, @md)
                  ON CONFLICT (businessentityid) DO NOTHING",
                _connection))
            {
                insertCmd.Parameters.AddWithValue("id", testId);
                insertCmd.Parameters.AddWithValue("nid", "TEST123");
                insertCmd.Parameters.AddWithValue("bd", new DateTime(1980, 1, 15));
                insertCmd.Parameters.AddWithValue("ms", "S");
                insertCmd.Parameters.AddWithValue("g", "M");
                insertCmd.Parameters.AddWithValue("md", DateTime.Now);
                await insertCmd.ExecuteNonQueryAsync();
            }

            // Call stored procedure
            using (var procCmd = new NpgsqlCommand(
                "CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@id, @nid, @bd, @ms, @g)",
                _connection))
            {
                procCmd.Parameters.AddWithValue("id", testId);
                procCmd.Parameters.AddWithValue("nid", "UPDATED456");
                procCmd.Parameters.AddWithValue("bd", new DateTime(1985, 5, 20));
                procCmd.Parameters.AddWithValue("ms", "M");
                procCmd.Parameters.AddWithValue("g", "M");
                await procCmd.ExecuteNonQueryAsync();
            }

            // Verify update
            using (var selectCmd = new NpgsqlCommand(
                "SELECT nationalidnumber FROM bobsusedbookstore_dbo.author WHERE businessentityid = @id",
                _connection))
            {
                selectCmd.Parameters.AddWithValue("id", testId);
                var result = await selectCmd.ExecuteScalarAsync();
                Assert.Equal("UPDATED456", result?.ToString());
            }

            // Cleanup
            using (var deleteCmd = new NpgsqlCommand(
                "DELETE FROM bobsusedbookstore_dbo.author WHERE businessentityid = @id",
                _connection))
            {
                deleteCmd.Parameters.AddWithValue("id", testId);
                await deleteCmd.ExecuteNonQueryAsync();
            }
        }

        [Fact]
        public async Task Statement3_DeleteStoredProcedure_DeletesAuthor()
        {
            // Test Statement 3: uspDeleteAuthor
            var testId = 999998;
            
            // Insert test data
            using (var insertCmd = new NpgsqlCommand(
                @"INSERT INTO bobsusedbookstore_dbo.author 
                  (businessentityid, nationalidnumber, birthdate, maritalstatus, gender, modifieddate)
                  VALUES (@id, @nid, @bd, @ms, @g, @md)",
                _connection))
            {
                insertCmd.Parameters.AddWithValue("id", testId);
                insertCmd.Parameters.AddWithValue("nid", "DELETE_TEST");
                insertCmd.Parameters.AddWithValue("bd", new DateTime(1980, 1, 15));
                insertCmd.Parameters.AddWithValue("ms", "S");
                insertCmd.Parameters.AddWithValue("g", "M");
                insertCmd.Parameters.AddWithValue("md", DateTime.Now);
                await insertCmd.ExecuteNonQueryAsync();
            }

            // Call delete stored procedure
            using (var procCmd = new NpgsqlCommand(
                "CALL bobsusedbookstore_dbo.uspdeleteauthor(@id)",
                _connection))
            {
                procCmd.Parameters.AddWithValue("id", testId);
                await procCmd.ExecuteNonQueryAsync();
            }

            // Verify deletion
            using (var selectCmd = new NpgsqlCommand(
                "SELECT COUNT(*) FROM bobsusedbookstore_dbo.author WHERE businessentityid = @id",
                _connection))
            {
                selectCmd.Parameters.AddWithValue("id", testId);
                var count = (long)(await selectCmd.ExecuteScalarAsync() ?? 0L);
                Assert.Equal(0, count);
            }
        }

        [Fact]
        public async Task Statement4_ComplexQuery_ReturnsFormattedResults()
        {
            // Test Statement 4: Complex query with T-SQL function conversions
            using var cmd = new NpgsqlCommand(
                @"SELECT 
                    businessentityid,
                    to_char(modifieddate, 'yyyy-MM-dd HH:mm:ss') AS formattedmodifieddate,
                    aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age
                  FROM bobsusedbookstore_dbo.author
                  WHERE date_part('year', COALESCE(hiredate, modifieddate)) >= 2000
                  LIMIT 1",
                _connection);
            
            using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                var formatted = reader.GetString(1);
                var age = reader.GetInt32(2);
                
                // Verify format: yyyy-MM-dd HH:mm:ss
                Assert.Matches(@"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}", formatted);
                
                // Verify age is reasonable (0-120)
                Assert.InRange(age, 0, 120);
            }
        }

        public void Dispose()
        {
            _connection?.Close();
            _connection?.Dispose();
        }
    }
}
```

**Run Integration Tests:**

```bash
# Set connection string environment variable
export DB_CONNECTION_STRING="Host=<host>;Port=5432;Database=BobsUsedBookStore;Username=bookstore_app;Password=<password>"

# Run tests
dotnet test tests/Bookstore.IntegrationTests/Bookstore.IntegrationTests.csproj

# Expected: All tests should pass
```

---

## Rollback Procedures

### Rollback Stored Procedures

```sql
-- Connect to database
\c BobsUsedBookStore

-- Drop stored procedures
DROP PROCEDURE IF EXISTS bobsusedbookstore_dbo.uspupdateauthorpersonalinfo;
DROP PROCEDURE IF EXISTS bobsusedbookstore_dbo.uspdeleteauthor;

-- Verify removal
SELECT routine_name FROM information_schema.routines 
WHERE routine_schema = 'bobsusedbookstore_dbo';
```

### Rollback Database

```sql
-- DANGER: This will delete all data
-- Only use if you need to start over

-- Disconnect all users
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE datname = 'BobsUsedBookStore' AND pid <> pg_backend_pid();

-- Drop database
DROP DATABASE IF EXISTS "BobsUsedBookStore";
```

### Rollback Application

```bash
# Revert to SQL Server connection string
# Update appsettings.json or environment variables back to SQL Server

# Rebuild application
dotnet clean
dotnet build
```

---

## Troubleshooting

### Issue 1: Cannot Connect to PostgreSQL

**Symptoms:**
- Connection timeout
- "could not connect to server" error

**Solutions:**
1. Verify PostgreSQL is running:
   ```bash
   pg_isready -h <host> -p 5432
   ```

2. Check security group/firewall rules allow port 5432

3. Verify credentials:
   ```bash
   psql -h <host> -U postgres -d postgres
   ```

4. Check connection string format in application

### Issue 2: aws_sqlserver_ext Extension Not Found

**Symptoms:**
- Error: "function aws_sqlserver_ext.datediff does not exist"

**Solutions:**
1. Verify extension is installed:
   ```sql
   SELECT * FROM pg_extension WHERE extname = 'aws_sqlserver_ext';
   ```

2. Install extension if missing:
   ```sql
   CREATE EXTENSION aws_sqlserver_ext;
   ```

3. If extension not available, you may need:
   - AWS RDS PostgreSQL (has extension pre-installed)
   - Or install from source: https://github.com/aws/postgresql-aws-s3

### Issue 3: Stored Procedure Call Fails

**Symptoms:**
- Error: "procedure does not exist"
- Error: "no function matches"

**Solutions:**
1. Verify stored procedures exist:
   ```sql
   SELECT routine_name FROM information_schema.routines 
   WHERE routine_schema = 'bobsusedbookstore_dbo';
   ```

2. Check parameter types match:
   ```sql
   SELECT routine_name, data_type 
   FROM information_schema.parameters 
   WHERE specific_schema = 'bobsusedbookstore_dbo';
   ```

3. Verify CALL syntax (not EXEC):
   ```csharp
   // Correct for PostgreSQL
   CALL bobsusedbookstore_dbo.uspdeleteauthor(@id)
   
   // Incorrect (SQL Server syntax)
   EXEC [dbo].[uspDeleteAuthor] @id
   ```

### Issue 4: Schema Not Found

**Symptoms:**
- Error: "schema bobsusedbookstore_dbo does not exist"

**Solutions:**
1. Create schema:
   ```sql
   CREATE SCHEMA bobsusedbookstore_dbo;
   ```

2. Verify schema exists:
   ```sql
   SELECT schema_name FROM information_schema.schemata;
   ```

3. Check application code uses correct schema name (case-sensitive in some contexts)

### Issue 5: Permission Denied

**Symptoms:**
- Error: "permission denied for schema"
- Error: "permission denied for table"

**Solutions:**
1. Grant necessary permissions:
   ```sql
   GRANT USAGE ON SCHEMA bobsusedbookstore_dbo TO bookstore_app;
   GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA bobsusedbookstore_dbo TO bookstore_app;
   GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA bobsusedbookstore_dbo TO bookstore_app;
   ```

2. Verify permissions:
   ```sql
   SELECT * FROM information_schema.role_table_grants 
   WHERE grantee = 'bookstore_app';
   ```

### Issue 6: Date Format Differences

**Symptoms:**
- Unexpected date formats in query results
- Date comparison errors

**Solutions:**
1. Verify to_char format string:
   ```sql
   SELECT to_char(CURRENT_TIMESTAMP, 'yyyy-MM-dd HH:mm:ss');
   ```

2. Use explicit casting:
   ```sql
   (birthdate)::TIMESTAMP
   ```

3. Check application date parsing matches PostgreSQL output format

---

## Success Criteria Checklist

Use this checklist to verify the deployment is complete:

### Database Deployment
- [ ] PostgreSQL instance is running and accessible
- [ ] Database "BobsUsedBookStore" is created
- [ ] Schema "bobsusedbookstore_dbo" exists
- [ ] All tables are migrated (verify count matches SQL Server)
- [ ] aws_sqlserver_ext extension is installed
- [ ] Stored procedures are deployed (2 procedures)
- [ ] Application user is created with proper permissions
- [ ] Data is migrated (if applicable)

### Application Configuration
- [ ] Connection string is updated to PostgreSQL format
- [ ] Application builds without errors
- [ ] Application starts without errors
- [ ] Application can connect to PostgreSQL database

### Functional Testing
- [ ] Statement 1 (Simple SELECT) works correctly
- [ ] Statement 2 (uspUpdateAuthorPersonalInfo) works correctly
- [ ] Statement 3 (uspDeleteAuthor) works correctly
- [ ] Statement 4 (Complex query with T-SQL functions) works correctly
- [ ] All application features work as expected
- [ ] No SQL-related errors in application logs

### Performance Testing
- [ ] Query performance is acceptable
- [ ] No significant performance degradation vs. SQL Server
- [ ] Connection pool is configured appropriately

### Documentation
- [ ] Deployment steps are documented
- [ ] Configuration changes are documented
- [ ] Test results are documented
- [ ] Any issues and resolutions are documented

---

## Next Steps After Deployment

1. **Monitor Application:**
   - Watch error logs for database-related issues
   - Monitor query performance
   - Track connection pool metrics

2. **Performance Tuning:**
   - Create indexes as needed
   - Analyze slow queries
   - Optimize connection pool settings

3. **Backup and Recovery:**
   - Set up automated backups
   - Test restore procedures
   - Document recovery process

4. **Security Hardening:**
   - Review and restrict database permissions
   - Enable SSL/TLS for connections
   - Implement connection encryption
   - Regular security audits

5. **Monitoring and Alerting:**
   - Set up database monitoring
   - Configure alerts for errors
   - Track key performance metrics

---

## Support and Resources

### Documentation
- PostgreSQL Official Documentation: https://www.postgresql.org/docs/
- Npgsql Documentation: https://www.npgsql.org/doc/
- AWS RDS PostgreSQL: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html
- aws_sqlserver_ext: https://github.com/aws/postgresql-aws-s3

### Migration Resources
- SQL Equivalency Validation Report: `sql_equivalency_validation_report.json`
- Extracted Statements: `extracted_statements.sql`
- Converted Statements: `converted_statements.sql`
- Statements Requiring Review: `statements_requiring_review.txt`
- DMS Conversion Failures: `dms_conversion_failures.log`

### Contact
- Migration Team: [Your Team Contact]
- Database Administrator: [DBA Contact]
- DevOps Team: [DevOps Contact]

---

**Document End**
