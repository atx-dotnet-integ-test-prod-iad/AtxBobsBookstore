-- Extracted SQL Statements from BobsBookstore Application
-- Source: MS SQL Server to PostgreSQL Migration
-- Total Statements: 5
-- Extraction Date: 2026-03-23

-- ============================================================================
-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure
-- Method: EditUsingStoredProcedure
-- Type: UPDATE statement
-- ============================================================================
UPDATE bobsbookstore_dbo.author SET nationalidnumber = @NationalIDNumber, birthdate = @BirthDate, maritalstatus = @MaritalStatus, gender = @Gender WHERE businessentityid = @BusinessEntityID

-- ============================================================================
-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql
-- Method: FindAllAuthorsEmbeddedSql
-- Type: SELECT statement
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql
-- Method: DeleteAuthorEmbeddedSql
-- Type: DELETE statement
-- ============================================================================
DELETE FROM bobsbookstore_dbo.author WHERE businessentityid = @BusinessEntityID

-- ============================================================================
-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear
-- Method: SelectAuthorsByHireYear
-- Type: Complex SELECT with PostgreSQL functions (TO_CHAR, EXTRACT, AGE)
-- ============================================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate

-- ============================================================================
-- Statement 5: ProductsController.cs - FindAllProducts
-- Method: FindAllProducts
-- Type: SELECT statement
-- ============================================================================
SELECT productid, name, productnumber, safetystocklevel FROM bobsbookstore_dbo.product
