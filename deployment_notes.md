# Deployment Notes
## BobsBookstore PostgreSQL Migration Deployment Guide

**Application:** BobsBookstore .NET ADO Web Application  
**Target Database:** PostgreSQL  
**Date:** 2026-01-27

---

## Prerequisites for Deployment

### 1. PostgreSQL Database Instance

**Required Version:**
- PostgreSQL 10 or higher (recommended: PostgreSQL 13+)
- Compatible with Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0

**Database Configuration:**
- Database Name: BobsUsedBookStore
- Required Schemas:
  * public (for stored procedures/functions)
  * bobsbookstore_dbo (for tables)

### 2. Database Schema

**Tables Required:**
- `bobsbookstore_dbo.author` - Author information table
- `bobsbookstore_dbo.product` - Product information table
- Additional tables as defined in Entity Framework models

**Table: bobsbookstore_dbo.author**
```sql
CREATE TABLE bobsbookstore_dbo.author (
    businessentityid INTEGER PRIMARY KEY,
    nationalidnumber VARCHAR(15) NOT NULL,
    loginid VARCHAR(256) NOT NULL,
    jobtitle VARCHAR(50) NOT NULL,
    birthdate TIMESTAMP NOT NULL,
    maritalstatus CHAR(1) NOT NULL,
    gender CHAR(1) NOT NULL,
    hiredate TIMESTAMP NOT NULL,
    vacationhours SMALLINT NOT NULL,
    modifieddate TIMESTAMP NOT NULL
);
```

**Table: bobsbookstore_dbo.product**
```sql
CREATE TABLE bobsbookstore_dbo.product (
    productid INTEGER PRIMARY KEY,
    name VARCHAR(15) NOT NULL,
    productnumber VARCHAR(256) NOT NULL,
    safetystocklevel INTEGER NOT NULL
);
```

---

## Stored Procedures/Functions to Create

### 1. uspUpdateAuthorPersonalInfo

**Purpose:** Update author personal information

**SQL Server Signature:**
```sql
CREATE PROCEDURE [dbo].[uspUpdateAuthorPersonalInfo]
    @BusinessEntityID INT,
    @NationalIDNumber NVARCHAR(15),
    @BirthDate DATETIME,
    @MaritalStatus NCHAR(1),
    @Gender NCHAR(1)
AS
-- Implementation
```

**PostgreSQL Function (To Be Created):**
```sql
CREATE OR REPLACE FUNCTION public.uspUpdateAuthorPersonalInfo(
    p_businessentityid INTEGER,
    p_nationalidnumber VARCHAR(15),
    p_birthdate TIMESTAMP,
    p_maritalstatus CHAR(1),
    p_gender CHAR(1)
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    UPDATE bobsbookstore_dbo.author
    SET 
        nationalidnumber = p_nationalidnumber,
        birthdate = p_birthdate,
        maritalstatus = p_maritalstatus,
        gender = p_gender,
        modifieddate = CURRENT_TIMESTAMP
    WHERE businessentityid = p_businessentityid;
    
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    RETURN v_rows_affected;
END;
$$;
```

**Notes:**
- Function must return INTEGER (rows affected)
- Called as: `SELECT public.uspUpdateAuthorPersonalInfo(@BusinessEntityID, ...)`
- Npgsql supports @parameter syntax

### 2. uspDeleteAuthor

**Purpose:** Delete an author

**SQL Server Signature:**
```sql
CREATE PROCEDURE [dbo].[uspDeleteAuthor]
    @BusinessEntityID INT
AS
-- Implementation
```

**PostgreSQL Function (To Be Created):**
```sql
CREATE OR REPLACE FUNCTION public.uspDeleteAuthor(
    p_businessentityid INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    DELETE FROM bobsbookstore_dbo.author
    WHERE businessentityid = p_businessentityid;
    
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    RETURN v_rows_affected;
END;
$$;
```

**Notes:**
- Function must return INTEGER (rows affected)
- Called as: `SELECT public.uspDeleteAuthor(@BusinessEntityID)`

### 3. uspGetProductData

**Purpose:** Retrieve all product data

**SQL Server Signature:**
```sql
CREATE PROCEDURE [dbo].[uspGetProductData]
AS
-- Implementation
```

**PostgreSQL Function (To Be Created):**
```sql
CREATE OR REPLACE FUNCTION public.uspGetProductData()
RETURNS TABLE (
    productid INTEGER,
    name VARCHAR(15),
    productnumber VARCHAR(256),
    safetystocklevel INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.productid,
        p.name,
        p.productnumber,
        p.safetystocklevel
    FROM bobsbookstore_dbo.product p;
END;
$$;
```

**Notes:**
- Function must return a result set
- Called as: `SELECT * FROM public.uspGetProductData()`

---

## Connection Configuration

### AWS Secrets Manager

**Secret Structure:**
```json
{
  "host": "your-postgresql-host.rds.amazonaws.com",
  "port": "5432",
  "username": "your_db_user",
  "password": "your_db_password"
}
```

**Configuration Parameter:**
- Parameter Name: `dbsecretsname`
- Current Value: `atx-db-modernization-secret-sql-admin`
- Update if secret name changed during database migration

### Connection String Format

**PostgreSQL Connection String:**
```
Host={host};Port={port};Database=BobsUsedBookStore;Username={username};Password={password};SSL Mode=Prefer
```

**SSL Mode Options:**
- **Disable:** No SSL encryption
- **Prefer:** Attempts SSL, falls back to non-SSL (current setting)
- **Require:** Requires SSL encryption
- **VerifyCA:** Requires SSL and verifies CA certificate
- **VerifyFull:** Requires SSL and verifies full certificate chain

**Recommendation for AWS RDS PostgreSQL:**
Use `SSL Mode=Require` for production environments.

---

## Deployment Steps

### 1. Database Setup

1. Create PostgreSQL database instance
2. Create required schemas: public, bobsbookstore_dbo
3. Migrate database schema from SQL Server to PostgreSQL
4. Create all required tables
5. Migrate data from SQL Server to PostgreSQL
6. Create 3 PostgreSQL functions (see above)
7. Verify database connectivity

### 2. Application Configuration

1. Update AWS Secrets Manager with PostgreSQL connection details
2. Verify `dbsecretsname` parameter points to correct secret
3. Adjust SSL Mode in connection string if needed
4. Configure connection pooling parameters if required

### 3. Application Deployment

1. Deploy application to target environment
2. Ensure .NET 8.0 runtime is installed
3. Verify Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 is available
4. Test database connectivity
5. Verify stored procedure calls work correctly

### 4. Verification Testing

1. Test all CRUD operations
2. Verify stored procedure functionality
3. Test complex queries with date functions
4. Validate data integrity
5. Check error handling
6. Monitor application logs

---

## Testing Recommendations

### Unit Testing

**Test Areas:**
- All controller methods
- Stored procedure calls
- Date function conversions
- Parameter handling
- Error handling

**Test Data:**
- Various date scenarios (leap years, edge cases)
- Null value handling
- Boundary conditions
- Invalid inputs

### Integration Testing

**Test Scenarios:**
- Complete CRUD workflows
- Transaction handling
- Concurrent operations
- Connection pool behavior
- Performance under load

### Data Validation

**Validation Checks:**
- Compare results between SQL Server and PostgreSQL
- Verify date calculations produce same results
- Check data integrity after migration
- Validate stored procedure behavior matches SQL Server

---

## Performance Considerations

### Indexing

Review and create appropriate indexes on:
- `bobsbookstore_dbo.author.businessentityid` (Primary Key)
- `bobsbookstore_dbo.author.hiredate` (Used in WHERE clause)
- `bobsbookstore_dbo.product.productid` (Primary Key)
- Additional indexes based on query patterns

### Connection Pooling

Configure connection pooling in connection string:
```
Host={host};Port={port};Database=BobsUsedBookStore;Username={username};Password={password};SSL Mode=Require;Minimum Pool Size=0;Maximum Pool Size=100
```

### Query Optimization

Monitor and optimize:
- Stored procedure performance
- Complex queries with date functions
- Index usage
- Query execution plans

---

## Troubleshooting

### Common Issues

**1. Connection Failures**
- Verify PostgreSQL instance is running
- Check firewall/security group rules
- Verify SSL configuration
- Confirm credentials in Secrets Manager

**2. Stored Procedure Errors**
- Ensure all 3 functions are created in public schema
- Verify function signatures match expected parameters
- Check return types match application expectations

**3. Date Function Issues**
- Test date calculations with various scenarios
- Verify timezone handling
- Check format string compatibility

**4. Performance Problems**
- Review indexes
- Analyze query execution plans
- Adjust connection pool settings
- Monitor database metrics

---

## Rollback Plan

If issues occur during deployment:

1. Keep SQL Server database available
2. Revert application to previous version
3. Update Secrets Manager to point back to SQL Server
4. Investigate and resolve PostgreSQL issues
5. Retry deployment after fixes

---

## Post-Deployment

### Monitoring

Monitor:
- Application logs for errors
- Database connection metrics
- Query performance
- Error rates
- Response times

### Optimization

After initial deployment:
- Analyze slow queries
- Optimize indexes
- Adjust connection pool settings
- Fine-tune PostgreSQL configuration

---

## Contact and Support

For issues or questions during deployment:
- Review transformation artifacts in project root
- Check final_migration_report.md for details
- Verify all stored procedures are created correctly
- Test with sample data before full deployment

---

**Deployment Checklist:**

- [ ] PostgreSQL database instance created
- [ ] All schemas created (public, bobsbookstore_dbo)
- [ ] All tables migrated
- [ ] 3 stored procedures/functions created
- [ ] AWS Secrets Manager configured
- [ ] Application deployed
- [ ] Database connectivity verified
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Performance acceptable
- [ ] Monitoring configured

---

**End of Deployment Notes**  
**Migration Date:** 2026-01-27  
**Version:** 1.0
