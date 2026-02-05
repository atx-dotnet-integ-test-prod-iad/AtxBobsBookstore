# Deployment Checklist
# SQL Server to PostgreSQL Migration - BobsBookstore Application

**Version**: 1.0  
**Date**: 2026-02-04  
**Application**: BobsBookstore.Web

---

## Pre-Deployment Verification

### Code Verification ✅

- [x] All SQL statements converted to PostgreSQL syntax
- [x] All SqlParameter replaced with NpgsqlParameter
- [x] Application builds successfully (0 errors)
- [x] Npgsql packages referenced in all projects
- [x] UseNpgsql() configured in ServicesSetup.cs
- [x] Schema mappings set to bobsbookstore_dbo
- [x] Connection string builder uses NpgsqlConnectionStringBuilder
- [x] All SQL Server syntax removed from code

### Documentation Verification ✅

- [x] extracted_statements.sql created
- [x] converted_statements.sql created
- [x] dms_conversion_log.json generated
- [x] sql_equivalency_validation_report.json completed
- [x] equivalency_validation_summary.md available
- [x] reintegration_log.md documented
- [x] parameter_migration_log.md created
- [x] connection_configuration_report.md generated
- [x] final_migration_report.md completed
- [x] migration_artifacts_index.md created
- [x] deployment_checklist.md (this file) available

---

## Infrastructure Provisioning

### PostgreSQL RDS Instance

- [ ] PostgreSQL RDS instance provisioned
  - **Engine**: PostgreSQL 14.x or higher
  - **Instance Class**: (to be determined based on workload)
  - **Storage**: (to be determined)
  - **Multi-AZ**: Recommended for production
  
- [ ] Security groups configured
  - **Inbound Rule**: Port 5432 from application subnet
  - **Outbound Rule**: As required
  
- [ ] VPC and subnet configuration
  - **VPC**: Same as application
  - **Subnet Group**: Private subnets recommended
  
- [ ] Backup configuration
  - **Automated Backups**: Enabled
  - **Backup Retention**: 7-30 days
  - **Backup Window**: Off-peak hours
  
- [ ] Monitoring and logging
  - **Enhanced Monitoring**: Enabled
  - **Performance Insights**: Enabled
  - **CloudWatch Logs**: Enabled

### Network Connectivity

- [ ] Network connectivity tested
  - Application server can reach PostgreSQL RDS on port 5432
  - DNS resolution working for RDS endpoint
  - Network ACLs allow traffic
  
- [ ] Bastion host or Jump box (if needed)
  - For direct database access and troubleshooting
  
- [ ] VPN or Direct Connect (if applicable)
  - For on-premises connectivity

---

## Database Migration

### Step 1: Create Database and Schema

```sql
-- Connect to PostgreSQL as superuser
psql -h <rds-endpoint> -U postgres -d postgres

-- Create schema
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;

-- Verify schema creation
\dn bobsbookstore_dbo
```

- [ ] Schema `bobsbookstore_dbo` created

### Step 2: Migrate Table Structures

**Option A: Using AWS DMS Schema Conversion Tool**
- [ ] Export SQL Server schema using DMS SCT
- [ ] Convert schema to PostgreSQL format
- [ ] Review and modify converted schema
- [ ] Execute schema creation scripts

**Option B: Using Entity Framework Migrations**
- [ ] Generate new PostgreSQL migration
  ```bash
  cd /path/to/Bookstore.Data
  dotnet ef migrations add InitialCreate --context ApplicationDbContext
  ```
- [ ] Review generated migration scripts
- [ ] Apply migration to PostgreSQL
  ```bash
  dotnet ef database update --context ApplicationDbContext
  ```

- [ ] Table structures created in bobsbookstore_dbo schema
- [ ] Verify tables:
  - [ ] bobsbookstore_dbo.author
  - [ ] bobsbookstore_dbo.product
  - [ ] bobsbookstore_dbo.address
  - [ ] bobsbookstore_dbo.book
  - [ ] bobsbookstore_dbo.customer
  - [ ] bobsbookstore_dbo.order
  - [ ] bobsbookstore_dbo.orderitem
  - [ ] bobsbookstore_dbo.offer
  - [ ] bobsbookstore_dbo.shoppingcart
  - [ ] bobsbookstore_dbo.shoppingcartitem
  - [ ] bobsbookstore_dbo.referencedata

### Step 3: Migrate Data

**Option A: Using AWS DMS**
- [ ] Create DMS replication instance
- [ ] Create source endpoint (SQL Server)
- [ ] Create target endpoint (PostgreSQL)
- [ ] Create migration task (full load)
- [ ] Start migration task
- [ ] Monitor migration progress
- [ ] Validate data completeness

**Option B: Using pg_dump and pg_restore**
- [ ] Export data from SQL Server (convert to PostgreSQL format)
- [ ] Import data to PostgreSQL
- [ ] Verify row counts match

- [ ] Data migrated to all tables
- [ ] Row counts verified
- [ ] Data integrity validated

### Step 4: Create Stored Procedures

**Required Stored Procedures**:

#### 1. uspupdateauthorpersonalinfo

```sql
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    p_businessentityid INTEGER,
    p_nationalidnumber VARCHAR(15),
    p_birthdate TIMESTAMP,
    p_maritalstatus CHAR(1),
    p_gender CHAR(1)
)
RETURNS INTEGER AS $$
DECLARE
    v_rowcount INTEGER;
BEGIN
    UPDATE bobsbookstore_dbo.author
    SET nationalidnumber = p_nationalidnumber,
        birthdate = p_birthdate,
        maritalstatus = p_maritalstatus,
        gender = p_gender,
        modifieddate = CURRENT_TIMESTAMP
    WHERE businessentityid = p_businessentityid;
    
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    RETURN v_rowcount;
END;
$$ LANGUAGE plpgsql;
```

- [ ] uspupdateauthorpersonalinfo created and tested

#### 2. uspdeleteauthor

```sql
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspdeleteauthor(
    p_businessentityid INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    v_rowcount INTEGER;
BEGIN
    DELETE FROM bobsbookstore_dbo.author
    WHERE businessentityid = p_businessentityid;
    
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    RETURN v_rowcount;
END;
$$ LANGUAGE plpgsql;
```

- [ ] uspdeleteauthor created and tested

#### 3. uspgetproductdata

```sql
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspgetproductdata()
RETURNS TABLE(
    productid INTEGER,
    name VARCHAR(15),
    productnumber VARCHAR(256),
    safetystocklevel INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.productid,
        p.name,
        p.productnumber,
        p.safetystocklevel
    FROM bobsbookstore_dbo.product p;
END;
$$ LANGUAGE plpgsql;
```

- [ ] uspgetproductdata created and tested

### Step 5: Verify Database Objects

- [ ] All tables exist in bobsbookstore_dbo schema
- [ ] All columns have correct data types
- [ ] All indexes created
- [ ] All foreign keys created
- [ ] All stored procedures/functions created
- [ ] Permissions granted to application user

```sql
-- Verify stored procedures
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema = 'bobsbookstore_dbo';

-- Expected output:
-- uspupdateauthorpersonalinfo
-- uspdeleteauthor
-- uspgetproductdata
```

---

## AWS Secrets Manager Configuration

### Update Database Secret

- [ ] Navigate to AWS Secrets Manager console
- [ ] Locate secret: `atx-db-modernization-jaabou-DBConnector-setup-bobsBookStoreDB-source-target-ExUSmt`
- [ ] Update secret value with PostgreSQL connection details:

```json
{
  "host": "<postgresql-rds-endpoint>",
  "port": 5432,
  "username": "<postgresql-username>",
  "password": "<postgresql-password>",
  "database": "postgres"
}
```

- [ ] Save secret changes
- [ ] Test secret retrieval:
  ```bash
  aws secretsmanager get-secret-value \
    --secret-id arn:aws:secretsmanager:us-east-1:789616364195:secret:atx-db-modernization-jaabou-DBConnector-setup-bobsBookStoreDB-source-target-ExUSmt \
    --query SecretString --output text
  ```

---

## Application Configuration

### Update appsettings.json (if needed)

- [ ] Verify `dbsecretsname` points to correct secret ARN
- [ ] Update any environment-specific settings
- [ ] Review logging configuration
- [ ] Verify AWS region settings

### Environment Variables

- [ ] Set environment variables (if used):
  - `ASPNETCORE_ENVIRONMENT`: Development/Staging/Production
  - `AWS_REGION`: us-east-1 (or appropriate region)
  - Additional environment-specific variables

---

## Unit Testing (Local)

### Test Database Connectivity

- [ ] Create test PostgreSQL database
- [ ] Update connection string for testing
- [ ] Run application locally
- [ ] Verify application connects to test PostgreSQL

### Test SQL Statements

#### Statement 1: uspUpdateAuthorPersonalInfo

```csharp
// Test update author functionality
var result = await EditUsingStoredProcedure(
    businessEntityId: 1,
    nationalIdNumber: "123456789",
    birthDate: new DateTime(1980, 1, 1),
    maritalStatus: "M",
    gender: "M"
);
// Verify: result == true
// Verify: Author record updated in database
```

- [ ] Test uspUpdateAuthorPersonalInfo with valid data
- [ ] Test with edge cases (null values, boundary dates)
- [ ] Verify row count returned correctly

#### Statement 2: SelectAuthorsByHireYear

```csharp
// Test date function conversions
var authors = await SelectAuthorsByHireYear(2020);
// Verify: FormattedModifiedDate format is correct
// Verify: Age calculation is accurate
```

- [ ] Test SelectAuthorsByHireYear with known data
- [ ] Verify date formatting (TO_CHAR output)
- [ ] Verify age calculation (DATE_PART/AGE output)
- [ ] Compare results with SQL Server (if available)

#### Statement 3: uspDeleteAuthor

```csharp
// Test delete author functionality
var result = await DeleteAuthorEmbeddedSql(businessEntityId: 999);
// Verify: result reflects actual deletion
```

- [ ] Test uspDeleteAuthor with existing record
- [ ] Test with non-existent record
- [ ] Verify row count returned correctly

#### Statement 4: FindAllAuthorsEmbeddedSql

```csharp
// Test simple SELECT
var authors = await FindAllAuthorsEmbeddedSql();
// Verify: All authors returned
// Verify: Data accuracy
```

- [ ] Test FindAllAuthorsEmbeddedSql
- [ ] Verify all columns populated correctly
- [ ] Compare row count with expected

#### Statement 5: FindAllProducts

```csharp
// Test product retrieval
var products = await FindAllProducts();
// Verify: All products returned
// Verify: Data completeness
```

- [ ] Test uspGetProductData function
- [ ] Verify all products returned
- [ ] Verify data accuracy

### Integration Testing

- [ ] Test complete user workflows (Create/Read/Update/Delete)
- [ ] Test transaction handling
- [ ] Test error handling and rollback
- [ ] Test concurrent operations
- [ ] Performance testing (compare with SQL Server baseline)

---

## Deployment to Staging/Test Environment

### Deploy Application

- [ ] Build application in Release mode
  ```bash
  dotnet build --configuration Release
  ```
- [ ] Run tests
  ```bash
  dotnet test
  ```
- [ ] Publish application
  ```bash
  dotnet publish --configuration Release --output ./publish
  ```
- [ ] Deploy to staging environment (EC2, App Runner, or ECS)

### Smoke Testing

- [ ] Application starts successfully
- [ ] Application connects to PostgreSQL
- [ ] Health check endpoint responds
- [ ] Basic CRUD operations work
- [ ] No errors in application logs

### Functional Testing

- [ ] Test all application features
- [ ] Test all Author CRUD operations
- [ ] Test all Product operations
- [ ] Test all Order operations
- [ ] Test authentication and authorization
- [ ] Test file uploads (if applicable)
- [ ] Test integrations (Rekognition, S3, etc.)

---

## Performance Validation

### Baseline Metrics (from SQL Server)

- [ ] Document baseline performance metrics
  - Query response times
  - Transaction throughput
  - Concurrent user capacity
  
### PostgreSQL Performance Testing

- [ ] Execute same workload on PostgreSQL
- [ ] Measure query response times
- [ ] Measure transaction throughput
- [ ] Identify slow queries
  ```sql
  -- Enable query logging
  ALTER DATABASE postgres SET log_statement = 'all';
  ALTER DATABASE postgres SET log_duration = on;
  ALTER DATABASE postgres SET log_min_duration_statement = 1000; -- 1 second
  ```

### Performance Tuning (if needed)

- [ ] Add indexes for frequently queried columns
- [ ] Analyze query execution plans
  ```sql
  EXPLAIN ANALYZE SELECT * FROM bobsbookstore_dbo.author WHERE hiredate > '2020-01-01';
  ```
- [ ] Tune PostgreSQL configuration parameters
- [ ] Review connection pooling settings

---

## Security Verification

### Database Security

- [ ] Application user has minimum required privileges
- [ ] Public schema access disabled
- [ ] SSL/TLS encryption enabled for connections
- [ ] Password policy enforced
- [ ] Audit logging enabled

### Application Security

- [ ] No database credentials in code or config files
- [ ] Secrets Manager access properly configured
- [ ] IAM roles properly scoped
- [ ] Security groups restrictive (least privilege)

---

## Monitoring and Alerting

### CloudWatch Setup

- [ ] Application logs forwarded to CloudWatch
- [ ] Database metrics monitored
- [ ] Custom metrics created (if needed)
- [ ] Dashboards created for key metrics

### Alarms

- [ ] Database CPU utilization alarm
- [ ] Database connection count alarm
- [ ] Application error rate alarm
- [ ] Response time degradation alarm

---

## Production Deployment

### Pre-Production Checklist

- [ ] All staging tests passed
- [ ] Performance meets or exceeds baseline
- [ ] Security audit completed
- [ ] Monitoring and alerting configured
- [ ] Rollback plan documented and tested
- [ ] Deployment window scheduled
- [ ] Stakeholders notified

### Deployment Steps

1. **Backup Current State**
   - [ ] Backup current SQL Server database
   - [ ] Backup application binaries
   - [ ] Document current application version

2. **Deploy to Production**
   - [ ] Deploy application to production environment
   - [ ] Update AWS Secrets Manager with production PostgreSQL credentials
   - [ ] Verify application starts successfully
   - [ ] Monitor logs for errors

3. **Verify Production Deployment**
   - [ ] Health check passes
   - [ ] Sample transactions execute successfully
   - [ ] No errors in logs
   - [ ] Database connections established

4. **Monitor Initial Operations**
   - [ ] Monitor for 1-2 hours post-deployment
   - [ ] Watch for error patterns
   - [ ] Monitor performance metrics
   - [ ] Review user feedback

---

## Post-Deployment Validation

### Functional Validation

- [ ] Test critical user workflows
- [ ] Verify all features operational
- [ ] Check report generation (if applicable)
- [ ] Validate data accuracy

### Performance Validation

- [ ] Response times within acceptable range
- [ ] Database CPU/memory within normal range
- [ ] No connection pool exhaustion
- [ ] No query timeout errors

### Data Validation

- [ ] Spot-check critical data
- [ ] Verify transactions complete correctly
- [ ] Check audit trails (if applicable)
- [ ] Validate data integrity

---

## Rollback Procedures

### If Issues Detected

**STOP DEPLOYMENT** if:
- Application cannot connect to database
- Critical functionality broken
- Data corruption detected
- Performance degradation > 50%

### Rollback Steps

1. **Immediate Actions**
   - [ ] Stop processing new transactions (if possible)
   - [ ] Document the issue (screenshots, logs, metrics)
   - [ ] Notify stakeholders

2. **Revert to Previous State**
   - [ ] Restore AWS Secrets Manager secret to SQL Server credentials
   - [ ] Redeploy previous application version
   - [ ] Verify application connects to SQL Server
   - [ ] Test critical functionality

3. **Post-Rollback**
   - [ ] Document root cause of failure
   - [ ] Plan remediation steps
   - [ ] Schedule new deployment window
   - [ ] Update deployment checklist

---

## Success Criteria

### Deployment Considered Successful When:

- [ ] Application running in production
- [ ] All features operational
- [ ] No critical errors in logs
- [ ] Performance meets baseline
- [ ] Database connections stable
- [ ] Monitoring shows healthy metrics
- [ ] User feedback positive
- [ ] 24-48 hours of stable operation

---

## Documentation Updates

- [ ] Update architecture diagrams
- [ ] Update database connection documentation
- [ ] Update runbooks
- [ ] Update incident response procedures
- [ ] Archive SQL Server documentation

---

## Team Training

- [ ] Train support team on PostgreSQL differences
- [ ] Document troubleshooting procedures
- [ ] Update operational runbooks
- [ ] Conduct knowledge transfer sessions

---

## Cleanup (After Successful Deployment)

### Short-term (1 week post-deployment)

- [ ] Monitor for issues
- [ ] Collect performance data
- [ ] Gather user feedback

### Medium-term (1 month post-deployment)

- [ ] Review monitoring data
- [ ] Optimize queries if needed
- [ ] Fine-tune PostgreSQL configuration

### Long-term (3-6 months post-deployment)

- [ ] Decommission SQL Server instance (if no longer needed)
- [ ] Remove SQL Server from disaster recovery plans
- [ ] Update compliance documentation
- [ ] Archive migration artifacts

---

## Sign-off

### Pre-Deployment Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Development Lead | | | |
| Database Administrator | | | |
| Operations Lead | | | |
| Product Owner | | | |

### Post-Deployment Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Development Lead | | | |
| Database Administrator | | | |
| Operations Lead | | | |
| Product Owner | | | |

---

**Checklist Version**: 1.0  
**Last Updated**: 2026-02-04  
**Maintained By**: AWS Transform CLI Executor Agent
