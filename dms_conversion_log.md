# DMS Conversion Log

## Migration Project Details
- **DMS ARN**: `arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U`
- **Region**: us-east-1
- **Source Database**: BobsBookstore (SQL Server 2019)
- **Target Database**: postgres (PostgreSQL 13)
- **Schema**: dbo
- **Server**: 172.31.82.226
- **Date**: 2026-03-24

## Summary
All 5 DMS conversion attempts failed with the same error: metadata model creation failure. Manual conversions were applied with lowercase schema object naming rules per the transformation definition.

---

## Statement 1: uspupdateauthorpersonalinfo stored procedure call

### Input
```sql
SELECT * FROM dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
```

### DMS Result
- **Status**: ERROR
- **Timestamp**: 2026-03-24T13:16:15.301453
- **Error**: `Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}`

### Manual Conversion
```sql
SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
```
- **Changes**: Removed `dbo.` schema prefix
- **Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

---

## Statement 2: Select all authors

### Input
```sql
SELECT * FROM author
```

### DMS Result
- **Status**: ERROR
- **Timestamp**: 2026-03-24T13:16:38.045307
- **Error**: `Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}`

### Manual Conversion
```sql
SELECT * FROM author
```
- **Changes**: None needed - already lowercase and PostgreSQL compatible
- **Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

---

## Statement 3: uspdeleteauthor stored procedure call

### Input
```sql
SELECT * FROM dbo.uspdeleteauthor(@BusinessEntityID);
```

### DMS Result
- **Status**: ERROR
- **Timestamp**: 2026-03-24T13:17:01.300434
- **Error**: `Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}`

### Manual Conversion
```sql
SELECT * FROM uspdeleteauthor(@BusinessEntityID);
```
- **Changes**: Removed `dbo.` schema prefix
- **Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

---

## Statement 4: Complex author age query

### Input
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
```

### DMS Result
- **Status**: ERROR
- **Timestamp**: 2026-03-24T13:17:25.951703
- **Error**: `Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}`

### Manual Conversion
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
```
- **Changes**: None needed - already uses PostgreSQL-native functions (TO_CHAR, EXTRACT, AGE, NOW, ::INT type cast), all lowercase
- **Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

---

## Statement 5: uspgetproductdata stored procedure call

### Input
```sql
SELECT * FROM dbo.uspgetproductdata();
```

### DMS Result
- **Status**: ERROR
- **Timestamp**: 2026-03-24T13:17:51.470830
- **Error**: `Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}`

### Manual Conversion
```sql
SELECT * FROM uspgetproductdata();
```
- **Changes**: Removed `dbo.` schema prefix
- **Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

---

## SQL Equivalency Validation Results

All 5 statement pairs were submitted to the SQL Equivalency tool (`sql-equivalency___validate_sql_equivalence`). All returned ERROR status with error message `'uniqueID'`, which appears to be an internal tool infrastructure error.

| Statement | Equivalency Status | Error |
|-----------|-------------------|-------|
| Statement 1 | ERROR | 'uniqueID' |
| Statement 2 | ERROR | 'uniqueID' |
| Statement 3 | ERROR | 'uniqueID' |
| Statement 4 | ERROR | 'uniqueID' |
| Statement 5 | ERROR | 'uniqueID' |

---

## Overall DMS Conversion Statistics
- **Total Statements Processed**: 5
- **DMS Successful Conversions**: 0
- **DMS Failed Conversions**: 5
- **Manual Conversions Applied**: 5
- **Root Cause**: DMS metadata model creation failure - no objects found according to selection rules
