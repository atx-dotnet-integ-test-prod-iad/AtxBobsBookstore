# DMS Failure Summary

## Overview
- **Total Statements Processed**: 5
- **DMS Successful Conversions**: 4
- **DMS Failed Conversions**: 1

## DMS Failure Details

### Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)

**Original Statement:**
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate
```

**DMS Error Output:**
```json
{
  "status": "error",
  "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'Statement definition is not valid.'}}\"}",
  "error_timestamp": "2026-03-23T10:00:59.503371"
}
```

**Root Cause:**
The statement contains PostgreSQL-specific syntax that DMS cannot parse as MS SQL Server input:
- `TO_CHAR()` function (PostgreSQL function, not available in MS SQL Server)
- `EXTRACT(YEAR FROM AGE(...))` (PostgreSQL-specific AGE function)
- `::INT` cast operator (PostgreSQL-specific type cast syntax)
- `CURRENT_DATE` (while available in both, combined with AGE it's PostgreSQL-specific)

**Manual Conversion:**
Applied `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA` approach. Since the statement already uses lowercase schema object names and PostgreSQL-compatible syntax, it was kept as-is:

```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate
```

**Note:** This statement was already written in PostgreSQL-compatible syntax in the source code. The DMS tool could not process it because it expects MS SQL Server input syntax, but the codebase had already been partially migrated to PostgreSQL syntax for this particular statement.
