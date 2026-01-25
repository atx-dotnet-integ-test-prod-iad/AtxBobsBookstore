# Manual Review Items - BobsBookstore PostgreSQL Migration

## Items Requiring Manual Review

This document lists SQL statements and areas that require manual review and testing before production deployment.

---

## Statement 4: Select Authors by Hire Year with Age Calculation

### Priority: HIGH

### Issue
The SQL Equivalency validation tool returned UNKNOWN (marked as ERROR per transformation requirements) for this statement due to the complexity of date function conversions.

### Original SQL (T-SQL)
```sql
SELECT BusinessEntityID, 
       FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
       DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
FROM bobsbookstore_dbo.author 
WHERE DATEPART(YEAR, HireDate) = @HireDate;
```

### Converted SQL (PostgreSQL)
```sql
SELECT BusinessEntityID, 
       TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
       DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
```

### Conversion Details
| T-SQL Function | PostgreSQL Equivalent | Notes |
|----------------|----------------------|-------|
| `FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss')` | `TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS')` | Format patterns differ |
| `DATEDIFF(YEAR, BirthDate, GETDATE())` | `DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate))` | Age calculation method differs |
| `DATEPART(YEAR, HireDate)` | `EXTRACT(YEAR FROM HireDate)` | Direct equivalent |
| `GETDATE()` | `CURRENT_TIMESTAMP` | Direct equivalent |

### Potential Issues
1. **Date Format Output:**
   - T-SQL FORMAT uses .NET format strings
   - PostgreSQL TO_CHAR uses different format patterns
   - Verify output matches expected format

2. **Age Calculation:**
   - DATEDIFF calculates simple year difference
   - AGE() calculates interval accounting for months/days
   - May produce different results near birthday boundaries

3. **Timezone Handling:**
   - GETDATE() returns server local time
   - CURRENT_TIMESTAMP may use different timezone
   - Verify consistency with .ToUniversalTime() in C# code

### Testing Required
- [ ] Compare output format with original SQL Server results
- [ ] Test age calculation with various birth dates
- [ ] Test edge cases: leap years, end of month, timezone boundaries
- [ ] Verify date filtering (WHERE EXTRACT) returns expected records
- [ ] Run side-by-side comparison SQL Server vs PostgreSQL

### Recommendation
Create unit tests with known input dates and expected outputs to validate the conversions produce identical results.

---

## Stored Procedures Migration Status

### Priority: MEDIUM

### Stored Procedures Identified
1. **uspUpdateAuthorPersonalInfo** - Update author personal info
2. **uspDeleteAuthor** - Delete author
3. **uspGetProductData** - Get product data

### Current Status
All stored procedure calls have been converted to direct SQL statements (UPDATE, DELETE, SELECT) which are functionally equivalent.

### Production Consideration
**Option 1: Keep Direct SQL (Current Implementation)**
- ✅ Pros: Simpler, no additional PostgreSQL function migration needed
- ⚠️ Cons: Loss of encapsulation, no server-side validation

**Option 2: Migrate to PostgreSQL Functions**
- ✅ Pros: Maintains encapsulation, server-side logic, similar to original design
- ⚠️ Cons: Requires additional migration effort, PostgreSQL function creation

### Testing Required
- [ ] Verify direct SQL UPDATE/DELETE operations maintain data integrity
- [ ] Test error handling for constraint violations
- [ ] Compare performance with stored procedure approach

### Recommendation
The current direct SQL implementation is suitable for production if business logic validation occurs in the application tier. Consider PostgreSQL functions only if server-side validation/logic is required.

---

## Parameter Handling

### Priority: LOW

### Current Implementation
- Using NpgsqlParameter with @ParameterName convention
- DateTime values converted to UTC using .ToUniversalTime()
- Parameter arrays passed to ExecuteSqlRawAsync and SqlQueryRaw

### Testing Required
- [ ] Verify parameter binding works correctly
- [ ] Test NULL parameter handling
- [ ] Validate DateTime UTC conversion consistency
- [ ] Test special characters in string parameters

### Known Considerations
- PostgreSQL also supports positional parameters ($1, $2, etc.)
- Named parameters (@name) work but are less common in PostgreSQL
- Current implementation is acceptable and functional

---

## Transaction Handling

### Priority: LOW

### Current Implementation
- Using Entity Framework Core transaction management
- No explicit transaction blocks in SQL statements
- DbContext handles transaction boundaries

### Testing Required
- [ ] Verify transaction rollback on errors
- [ ] Test concurrent access scenarios
- [ ] Validate isolation level behavior

### Known Considerations
- PostgreSQL default isolation level is READ COMMITTED (same as SQL Server)
- EF Core transaction handling is database-agnostic
- No changes required unless explicit transaction SQL exists

---

## Connection String and Configuration

### Priority: LOW

### Current Implementation
- ✅ Using NpgsqlConnectionStringBuilder
- ✅ Connection parameters from AWS Secrets Manager
- ✅ DbContext configured with UseNpgsql

### Testing Required
- [ ] Verify connection to PostgreSQL database
- [ ] Test connection pooling behavior
- [ ] Validate AWS Secrets Manager integration

---

## Summary of Manual Review Requirements

| Priority | Item | Action Required | Estimated Effort |
|----------|------|----------------|------------------|
| HIGH | Statement 4 Date Functions | Testing and validation | 2-4 hours |
| MEDIUM | Stored Procedures Decision | Evaluate and decide | 1-2 hours |
| LOW | Parameter Handling | Verification testing | 1 hour |
| LOW | Transaction Handling | Basic testing | 1 hour |
| LOW | Connection Configuration | Connectivity test | 30 minutes |

**Total Estimated Effort:** 5.5 - 8.5 hours

---

## Sign-off Checklist

- [ ] Statement 4 tested and validated
- [ ] All CRUD operations tested against PostgreSQL
- [ ] Performance benchmarks compared
- [ ] Error handling verified
- [ ] Production deployment plan reviewed
- [ ] Rollback plan documented
- [ ] Monitoring and logging configured

---

## Additional Notes

### Database Schema Migration
This code migration assumes the database schema has been separately migrated from SQL Server to PostgreSQL. Verify that:
- [ ] All tables exist in PostgreSQL
- [ ] All columns have correct data types
- [ ] All constraints are properly migrated
- [ ] Indexes are created for performance

### Known Limitations
1. SQL Equivalency tool could not validate Statement 4 due to complexity
2. DMS tool metadata model was incomplete for this project
3. Manual conversions were necessary for all statements

### Future Improvements
1. Consider automated integration testing suite
2. Implement PostgreSQL-specific optimizations
3. Review and optimize query performance
4. Consider PostgreSQL-specific features (e.g., JSONB, full-text search)
