-- ============================================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Purpose: All SQL statements converted from SQL Server to PostgreSQL
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Failure Reason: Metadata model creation failed - No objects were found
--                     according to the specified selection rules.
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 165
-- Method: EditUsingStoredProcedure
-- Conversion: EXEC stored procedure call -> SELECT * FROM function call (PostgreSQL)
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 189
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion: Already PostgreSQL-compatible, schema/table names already lowercase
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 212
-- Method: DeleteAuthorEmbeddedSql
-- Conversion: EXEC stored procedure call -> SELECT * FROM function call (PostgreSQL)
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 232
-- Method: SelectAuthorsByHireYear
-- Conversion: Column names converted to lowercase for PostgreSQL compatibility
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_DATE, birthdate))::int AS age FROM bobsbookstore_dbo.author WHERE DATE_PART('year', hiredate) = @HireDate;

-- Statement 5: FindAllProducts (Converted)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line: 36
-- Method: FindAllProducts
-- Conversion: EXEC stored procedure call -> SELECT * FROM function call (PostgreSQL)
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
