# Migration Completion Checklist

## Runtime Verification Steps

### 1. Database Connectivity
- [ ] Verify PostgreSQL instance is running
- [ ] Update AWS Secrets Manager with PostgreSQL connection string
- [ ] Test application startup and database connection
- [ ] Verify schema "bobsbookstore_dbo" exists

### 2. PostgreSQL Functions/Procedures
- [ ] Create or verify function: bobsbookstore_dbo.uspupdateauthorpersonalinfo
- [ ] Create or verify function: bobsbookstore_dbo.uspdeleteauthor
- [ ] Create or verify function: bobsbookstore_dbo.uspgetproductdata
- [ ] Test function signatures match parameter expectations

### 3. SQL Operations Testing
- [ ] Test AuthorsController.FindAllAuthorsEmbeddedSql (simple SELECT)
- [ ] Test AuthorsController.EditUsingStoredProcedure (update function)
- [ ] Test AuthorsController.DeleteAuthorEmbeddedSql (delete function)
- [ ] Test AuthorsController.SelectAuthorsByHireYear (date functions)
- [ ] Test ProductsController.FindAllProducts (product function)

### 4. Date/Time Function Validation
- [ ] Verify TO_CHAR formatting matches expected output
- [ ] Verify AGE + EXTRACT correctly calculates age
- [ ] Verify EXTRACT(YEAR FROM HireDate) filters correctly

### 5. Integration Tests
- [ ] Run all existing unit tests
- [ ] Run all integration tests
- [ ] Verify transaction handling
- [ ] Test error scenarios

### 6. Performance Validation
- [ ] Compare query performance with SQL Server baseline
- [ ] Verify acceptable response times
- [ ] Check for any performance regressions

## Manual Review Items

### Statements with ERROR Equivalency Status
1. **uspUpdateAuthorPersonalInfo** - Verify update logic and row count return
2. **uspDeleteAuthor** - Verify delete logic and row count return
3. **SelectAuthorsByHireYear** - Verify date calculations produce correct results
4. **uspGetProductData** - Verify complete product data retrieval

## Sign-off

- [ ] All runtime tests passed
- [ ] All manual review items addressed
- [ ] Performance validated
- [ ] Migration approved for production

**Date:** _______________  
**Reviewer:** _______________  
**Status:** _______________
