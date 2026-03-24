-- ============================================================================
-- Extracted SQL Statements Catalog
-- Source: MS SQL Server to PostgreSQL Migration
-- Date: 2026-03-24
-- Description: Original MS SQL Server statements extracted from the codebase
--              for conversion via DMS MCP tool
-- Total Statements: 8
-- Scan Coverage: All .cs files (excluding bin/obj) and all .sql files in db/
-- Scan Patterns: SELECT, INSERT, UPDATE, DELETE, EXEC, CREATE, ALTER, DROP,
--                ExecuteSqlRaw, SqlQueryRaw, FromSqlRaw, FromSqlInterpolated
-- ============================================================================

-- ============================================================================
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure method (line ~164)
-- Original MS SQL Server stored procedure call with parameters
-- Method: EditUsingStoredProcedure(int, string, DateTime, string, string)
-- Context: Calls stored procedure to update author personal info
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;

-- Statement 2: FindAllAuthorsEmbeddedSql method (line ~188)
-- Original MS SQL Server simple SELECT to retrieve all authors
-- Method: FindAllAuthorsEmbeddedSql()
-- Context: Used via SqlQueryRaw<Author> to get list of all authors
SELECT * FROM [dbo].[Author];

-- Statement 3: DeleteAuthorEmbeddedSql method (line ~210)
-- Original MS SQL Server stored procedure call with parameter
-- Method: DeleteAuthorEmbeddedSql(int)
-- Context: Calls stored procedure to delete an author by BusinessEntityID
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;

-- Statement 4: SelectAuthorsByHireYear method (line ~230)
-- Original MS SQL Server complex SELECT with CONVERT, DATEDIFF, GETDATE, YEAR
-- Method: SelectAuthorsByHireYear(int)
-- Context: Used via SqlQueryRaw<AuthorAgeResult> to get authors filtered by hire year
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;

-- ============================================================================
-- Source: app/Bookstore.Web/Controllers/ProductsController.cs
-- ============================================================================

-- Statement 5: FindAllProducts method (line ~35)
-- Original MS SQL Server stored procedure call to retrieve product data
-- Method: FindAllProducts()
-- Context: Used via SqlQueryRaw<Product> to get list of all products
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- Source: db/adven.sql (Representative CREATE TABLE)
-- ============================================================================

-- Statement 6: Representative CREATE TABLE from db scripts
-- Original MS SQL Server DDL with IDENTITY, NVARCHAR, NCHAR, BIT, DATETIME, ON [PRIMARY]
-- Context: Author table definition from database setup scripts
CREATE TABLE [dbo].[Author]([BusinessEntityID] [int] IDENTITY(1,1) NOT NULL, [NationalIDNumber] [nvarchar](15) NOT NULL, [LoginID] [nvarchar](256) NOT NULL, [JobTitle] [nvarchar](50) NOT NULL, [BirthDate] [date] NOT NULL, [MaritalStatus] [nchar](1) NOT NULL, [Gender] [nchar](1) NOT NULL, [HireDate] [date] NOT NULL, [VacationHours] [smallint] NOT NULL, [CurrentFlag] [bit] NOT NULL, [ModifiedDate] [datetime] NOT NULL, PRIMARY KEY CLUSTERED ([BusinessEntityID] ASC)) ON [PRIMARY];

-- ============================================================================
-- Source: db/adven-data.sql (Representative INSERT)
-- ============================================================================

-- Statement 7: Representative INSERT from db scripts
-- Original MS SQL Server DML with N prefix Unicode strings, BIT value as integer
-- Context: Sample data insertion for Author table
INSERT INTO [dbo].[Author] ([NationalIDNumber], [LoginID], [JobTitle], [BirthDate], [MaritalStatus], [Gender], [HireDate], [VacationHours], [CurrentFlag], [ModifiedDate]) VALUES (N'295847284', N'adventure-works\ken0', N'Chief Executive Officer', '1969-01-29', N'S', N'M', '2009-01-14', 99, 1, '2014-06-30');

-- ============================================================================
-- Source: db/bobsusedbooks.sql (Representative CREATE VIEW)
-- ============================================================================

-- Statement 8: Representative CREATE VIEW from db scripts
-- Original MS SQL Server DDL with ROW_NUMBER, schema-qualified references
-- Context: View to retrieve top 10 members by total order sum
CREATE VIEW [dbo].[VwTopMembers] AS SELECT * FROM (SELECT CustomerID, FirstName, LastName, Email, TotalOrderSum, ROW_NUMBER() OVER (ORDER BY TotalOrderSum DESC) AS RowNum FROM [dbo].[Members]) AS RankedMembers WHERE RowNum <= 10;
