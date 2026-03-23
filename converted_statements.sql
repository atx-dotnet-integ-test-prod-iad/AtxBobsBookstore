-- ============================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore SQL Server to PostgreSQL Migration
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all statements)
-- ============================================

-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion: T-SQL DECLARE/EXEC stored procedure call -> PostgreSQL SELECT function call with lowercase schema
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion: Already PostgreSQL-compatible, schema already lowercase
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion: T-SQL DECLARE/EXEC stored procedure call -> PostgreSQL SELECT function call with lowercase schema
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion: Column names lowercased for PostgreSQL compatibility
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_DATE, birthdate))::int AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion: T-SQL EXEC stored procedure call -> PostgreSQL SELECT function call with lowercase schema
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
