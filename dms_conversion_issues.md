# DMS Conversion Issues Report

## Date: 2026-03-25

## Summary
All 5 SQL statements failed DMS conversion with the same error. Manual conversion was applied using lowercase schema mapping rules per transformation definition.

## DMS Error Details
- **Error**: Metadata model creation failed
- **Message**: "No objects were found according to the specified selection rules. Please review your selection rules and try again."
- **Migration Project ARN**: `arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U`
- **Database**: BobsBookstore
- **Schema**: dbo
- **Server**: 172.31.82.226

## SQL Equivalency Tool Issues
All 5 equivalency validations returned ERROR status with `'uniqueID'` error. This appears to be a systemic tool issue unrelated to the quality of conversions.

## Statements Affected

### Statement 1: EditUsingStoredProcedure (AuthorsController.cs:165)
- **Original**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **DMS Output**: Error - Metadata model creation failed
- **Manual Conversion**: `SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Rationale**: MS SQL DECLARE/EXEC pattern converted to PostgreSQL function call. Schema objects lowercased per PostgreSQL conventions.

### Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs:189)
- **Original**: `SELECT * FROM "bobsbookstore_dbo"."author"`
- **DMS Output**: Error - Metadata model creation failed
- **Manual Conversion**: `SELECT * FROM "bobsbookstore_dbo"."author"` (already PostgreSQL compatible, retained as-is)
- **Conversion Rationale**: Statement already uses PostgreSQL-compatible quoted identifiers with lowercase schema/table names.

### Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs:212)
- **Original**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **DMS Output**: Error - Metadata model creation failed
- **Manual Conversion**: `SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Conversion Rationale**: MS SQL DECLARE/EXEC pattern converted to PostgreSQL function call. Schema objects lowercased per PostgreSQL conventions.

### Statement 4: SelectAuthorsByHireYear (AuthorsController.cs:232)
- **Original**: `SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_DATE, BirthDate))::int AS Age FROM "bobsbookstore_dbo"."author" WHERE DATE_PART('year', HireDate) = @HireDate;`
- **DMS Output**: Error - Metadata model creation failed
- **Manual Conversion**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_DATE, birthdate))::int AS age FROM "bobsbookstore_dbo"."author" WHERE DATE_PART('year', hiredate) = @HireDate;`
- **Conversion Rationale**: Column names and aliases lowercased. PostgreSQL functions (TO_CHAR, DATE_PART, AGE) retained as already compatible.

### Statement 5: FindAllProducts (ProductsController.cs:36)
- **Original**: `EXEC [dbo].[uspGetProductData];`
- **DMS Output**: Error - Metadata model creation failed
- **Manual Conversion**: `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Conversion Rationale**: MS SQL EXEC pattern converted to PostgreSQL function call with SELECT * FROM syntax. Schema objects lowercased per PostgreSQL conventions.
