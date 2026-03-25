-- =============================================================================
-- Extracted SQL Statements Catalog
-- Project: BobsBookstore - SQL Server to PostgreSQL Migration
-- Description: Comprehensive catalog of ALL SQL statements found in the codebase
--              with original MS SQL Server equivalents for DMS conversion.
-- Total Statements: 5
-- =============================================================================

-- =============================================================================
-- Statement 1: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Line: ~187
-- Context: Retrieves all author records from the Author table
-- =============================================================================
-- Original MS SQL Server Statement:
SELECT * FROM [dbo].[Author]
-- Current PostgreSQL Statement (in code):
-- SELECT * FROM bobsbookstore_dbo.author

-- =============================================================================
-- Statement 2: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Line: ~163
-- Context: Calls stored procedure to update author personal info
-- =============================================================================
-- Original MS SQL Server Statement:
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- Current PostgreSQL Statement (in code):
-- SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- =============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Line: ~208
-- Context: Calls stored procedure to delete an author by BusinessEntityID
-- =============================================================================
-- Original MS SQL Server Statement:
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
-- Current PostgreSQL Statement (in code):
-- SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- =============================================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Line: ~228
-- Context: Complex SELECT with date functions, type conversion, and age calculation
-- =============================================================================
-- Original MS SQL Server Statement:
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate
-- Current PostgreSQL Statement (in code):
-- SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- =============================================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Line: ~34
-- Context: Calls stored procedure to retrieve all product data
-- =============================================================================
-- Original MS SQL Server Statement:
EXEC [dbo].[uspGetProductData]
-- Current PostgreSQL Statement (in code):
-- SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- =============================================================================
-- DMS Configuration Settings (from qtransform-generated-input.json):
-- Migration Project ARN: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- Source Database: BobsBookstore
-- Schema: dbo
-- Region: us-east-1
-- =============================================================================
