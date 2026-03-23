-- Converted SQL Statements for PostgreSQL - BobsBookstore Application
-- Target: PostgreSQL
-- Total Statements: 5
-- Conversion Date: 2026-03-23

-- ============================================================================
-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure
-- Conversion Method: DMS_TOOL (Success)
-- ============================================================================
UPDATE bobsbookstore_dbo.author SET nationalidnumber = @NationalIDNumber, birthdate = @BirthDate, maritalstatus = @MaritalStatus, gender = @Gender WHERE businessentityid = @BusinessEntityID;

-- ============================================================================
-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql
-- Conversion Method: DMS_TOOL (Success)
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql
-- Conversion Method: DMS_TOOL (Success)
-- ============================================================================
DELETE FROM bobsbookstore_dbo.author WHERE businessentityid = @BusinessEntityID;

-- ============================================================================
-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Statement definition is not valid (PostgreSQL-specific functions not parseable by DMS)
-- Manual conversion applied with lowercase schema object names
-- ============================================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate

-- ============================================================================
-- Statement 5: ProductsController.cs - FindAllProducts
-- Conversion Method: DMS_TOOL (Success)
-- ============================================================================
SELECT productid, name, productnumber, safetystocklevel FROM bobsbookstore_dbo.product;
