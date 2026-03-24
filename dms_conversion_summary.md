# DMS Conversion Summary

## Overview
- **Application**: BobsBookstore
- **Migration**: MS SQL Server → PostgreSQL
- **DMS Migration Project**: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- **Database**: BobsBookstore
- **Schema**: dbo
- **Region**: us-east-1
- **Total Statements**: 5
- **DMS Successful Conversions**: 0
- **Manual Conversions Required**: 5

## DMS Error Details
All 5 statements failed with the same error:
```
Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
```

## Manual Conversion Details (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)

### Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: EditUsingStoredProcedure
- **Original MS SQL**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **DMS Output**: ERROR - Metadata model creation failed
- **Manual PostgreSQL Conversion**:
  ```sql
  SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **Conversion Notes**: EXEC with stored procedure call converted to SELECT function call with PostgreSQL lowercase schema. DECLARE/SELECT @rowsAffected wrapper removed as PostgreSQL function returns result directly.

### Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: FindAllAuthorsEmbeddedSql
- **Original MS SQL**:
  ```sql
  SELECT * FROM [dbo].[Author]
  ```
- **DMS Output**: ERROR - Metadata model creation failed
- **Manual PostgreSQL Conversion**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.author
  ```
- **Conversion Notes**: Schema reference [dbo].[Author] converted to bobsbookstore_dbo.author (lowercase).

### Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: DeleteAuthorEmbeddedSql
- **Original MS SQL**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **DMS Output**: ERROR - Metadata model creation failed
- **Manual PostgreSQL Conversion**:
  ```sql
  SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
  ```
- **Conversion Notes**: EXEC with stored procedure call converted to SELECT function call with PostgreSQL lowercase schema. DECLARE/SELECT @rowsAffected wrapper removed.

### Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: SelectAuthorsByHireYear
- **Original MS SQL**:
  ```sql
  SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate
  ```
- **DMS Output**: ERROR - Metadata model creation failed
- **Manual PostgreSQL Conversion**:
  ```sql
  SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
  ```
- **Conversion Notes**:
  - CONVERT(VARCHAR, ModifiedDate, 120) → TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')
  - DATEDIFF(YEAR, BirthDate, GETDATE()) → EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INTEGER
  - YEAR(HireDate) → EXTRACT(YEAR FROM hiredate)
  - All column/table names converted to lowercase
  - Schema reference [dbo].[Author] → bobsbookstore_dbo.author

### Statement 5: FindAllProducts (ProductsController.cs)
- **Source File**: app/Bookstore.Web/Controllers/ProductsController.cs
- **Method**: FindAllProducts
- **Original MS SQL**:
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **DMS Output**: ERROR - Metadata model creation failed
- **Manual PostgreSQL Conversion**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
  ```
- **Conversion Notes**: EXEC stored procedure call converted to SELECT * FROM function call with PostgreSQL lowercase schema.
