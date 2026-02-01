-- =====================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- BobsBookstore .NET Application - SQL Server to PostgreSQL Migration
-- =====================================================================
-- This file catalogs all SQL statements extracted from the codebase
-- for conversion from SQL Server syntax to PostgreSQL syntax.
-- =====================================================================

-- =====================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- =====================================================================
-- Location: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: ~163
-- Context: Updates author personal information using stored procedure
-- 
-- Original SQL Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int)
-- @NationalIDNumber (string)
-- @BirthDate (DateTime - converted to UTC)
-- @MaritalStatus (string)
-- @Gender (string)
-- 
-- Usage: Called from Edit action when updating author via stored procedure
-- =====================================================================

-- =====================================================================
-- STATEMENT 2: Select All Authors
-- =====================================================================
-- Location: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: ~192
-- Context: Retrieves all authors from the database
-- 
-- Original SQL Statement:
SELECT * FROM bobsbookstore_dbo.author

-- Parameters: None
-- 
-- Usage: Called from Index action to display all authors
-- Returns: List<Author>
-- =====================================================================

-- =====================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- =====================================================================
-- Location: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: ~207
-- Context: Deletes author using stored procedure
-- 
-- Original SQL Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int)
-- 
-- Usage: Called from DeleteConfirmed action when deleting an author
-- =====================================================================

-- =====================================================================
-- STATEMENT 4: Select Authors By Hire Year with Date Functions
-- =====================================================================
-- Location: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: ~228
-- Context: Retrieves authors hired in a specific year with formatted date and calculated age
-- 
-- Original SQL Statement:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Parameters:
-- @HireDate (int) - year value
-- 
-- Usage: Called from OtherAuthors action to display authors by hire year
-- Returns: List<AuthorAgeResult>
-- 
-- SQL Server Specific Functions Used:
-- - FORMAT() - Date formatting function
-- - DATEDIFF() - Date difference calculation
-- - GETDATE() - Current date/time function
-- - DATEPART() - Extract part of date (year)
-- =====================================================================

-- =====================================================================
-- SCHEMA INFORMATION
-- =====================================================================
-- Schema Name: bobsbookstore_dbo
-- Table: author
-- 
-- Columns (from ApplicationDbContext.cs):
-- - BusinessEntityID (int) - Primary Key - mapped to businessentityid
-- - NationalIDNumber (string) - mapped to nationalidnumber
-- - LoginID (string) - mapped to loginid
-- - JobTitle (string) - mapped to jobtitle
-- - BirthDate (DateTime) - mapped to birthdate
-- - MaritalStatus (string) - mapped to maritalstatus
-- - Gender (string) - mapped to gender
-- - HireDate (DateTime) - mapped to hiredate
-- - VacationHours (int) - mapped to vacationhours
-- - ModifiedDate (DateTime) - mapped to modifieddate
-- =====================================================================

-- =====================================================================
-- STATEMENT 5: Get Product Data (Stored Procedure Call)
-- =====================================================================
-- Location: /sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Number: ~33
-- Context: Retrieves all product data using stored procedure
-- 
-- Original SQL Statement:
EXEC [dbo].[uspGetProductData];

-- Parameters: None
-- 
-- Usage: Called from Index action to display all products
-- Returns: List<Product>
-- =====================================================================

-- =====================================================================
-- TOTAL STATEMENTS EXTRACTED: 5
-- =====================================================================
-- Statements with Stored Procedures: 3 (Statement 1, Statement 3, Statement 5)
-- Statements with SQL Server Date Functions: 1 (Statement 4)
-- Statements with Basic SELECT: 1 (Statement 2)
-- =====================================================================
