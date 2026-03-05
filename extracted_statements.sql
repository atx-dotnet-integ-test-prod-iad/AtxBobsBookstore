-- ============================================================================
-- Extracted SQL Statements Catalog (COMPLETE)
-- Source: BobsBookstore .NET Application + Database Scripts
-- Extraction Date: 2026-03-05
-- Re-processed Date: 2026-03-05 (All statements re-processed through DMS)
-- Total Statements: 8 (5 from application code + 3 from database scripts)
-- ============================================================================
-- Comprehensive scan performed on all .cs files in:
--   app/Bookstore.Web/Controllers/ (11 files)
--   app/Bookstore.Data/ (all .cs files)
--   app/Bookstore.Domain/ (all .cs files)
-- And all SQL files in db/ directory:
--   db/bobsusedbooks.sql (5878 lines)
--   db/adven.sql (4341 lines)
--   db/adven-data.sql (2977 lines)
-- ============================================================================

-- =============================================
-- APPLICATION CODE SQL STATEMENTS (5)
-- =============================================

-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: EditUsingStoredProcedure method, line ~163
-- Type: Compound DECLARE/EXEC/SELECT (Stored Procedure Call with return value)
-- Context: Updates author personal info via stored procedure
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: FindAllAuthorsEmbeddedSql method, line ~187
-- Type: SELECT query
-- Context: Retrieves all authors from the Author table
SELECT * FROM Author

-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: DeleteAuthorEmbeddedSql method, line ~208
-- Type: Compound DECLARE/EXEC/SELECT (Stored Procedure Call with return value)
-- Context: Deletes an author via stored procedure
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: SelectAuthorsByHireYear method, line ~228
-- Type: SELECT query with SQL Server specific functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- Context: Selects authors by hire year with age calculation
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Location: FindAllProducts method, line ~34
-- Type: EXEC (Stored Procedure Call)
-- Context: Retrieves all product data via stored procedure
EXEC [dbo].[uspGetProductData];

-- =============================================
-- DATABASE SCRIPT SQL STATEMENTS (3 representative)
-- =============================================

-- Statement 6: CREATE TABLE Author
-- Source File: db/adven.sql
-- Location: Line 432
-- Type: CREATE TABLE
-- Context: Author table definition
CREATE TABLE [dbo].[Author]( [BusinessEntityID] INT IDENTITY(1, 1) NOT NULL, [NationalIDNumber] nvarchar(15) NOT NULL, [LoginID] nvarchar(256) NOT NULL, [OrganizationNode] nvarchar(50) NULL, [JobTitle] nvarchar(50) NOT NULL, [BirthDate] date NOT NULL, [MaritalStatus] nchar(1) NOT NULL, [Gender] nchar(1) NOT NULL, [HireDate] date NOT NULL, [VacationHours] smallint NOT NULL DEFAULT ((0)), [CurrentFlag] bit NOT NULL DEFAULT ((1)), [ModifiedDate] datetime NOT NULL DEFAULT (getdate()) ) ON [PRIMARY];

-- Statement 7: CREATE TABLE Product
-- Source File: db/adven.sql
-- Location: Line 481
-- Type: CREATE TABLE
-- Context: Product table definition
CREATE TABLE [dbo].[Product]( [ProductID] int IDENTITY(1, 1) NOT NULL, [Name] nvarchar(50) NOT NULL, [ProductNumber] nvarchar(25) NOT NULL, [MakeFlag] bit NOT NULL DEFAULT ((1)), [FinishedGoodsFlag] bit NOT NULL DEFAULT ((1)), [Color] nvarchar(15) NULL, [SafetyStockLevel] smallint NOT NULL, [ReorderPoint] smallint NOT NULL, [StandardCost] money NOT NULL, [ListPrice] money NOT NULL, [Size] nvarchar(5) NULL, [SizeUnitMeasureCode] nchar(3) NULL, [WeightUnitMeasureCode] nchar(3) NULL, [Weight] decimal(8,2) NULL, [DaysToManufacture] int NOT NULL, [ProductLine] nchar(2) NULL, [Class] nchar(2) NULL, [Style] nchar(2) NULL, [ProductSubcategoryID] int NULL, [ProductModelID] int NULL, [SellStartDate] datetime NOT NULL, [SellEndDate] datetime NULL, [DiscontinuedDate] datetime NULL, [rowguid] uniqueidentifier NOT NULL DEFAULT (newid()), [ModifiedDate] datetime NOT NULL DEFAULT (getdate()) ) ON [PRIMARY];

-- Statement 8: INSERT INTO Author (representative sample)
-- Source File: db/adven-data.sql
-- Location: Line 30
-- Type: INSERT
-- Context: Author data population (1 of ~290 rows)
INSERT INTO [dbo].[Author] ([NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], [Gender], [HireDate], [VacationHours], [CurrentFlag], [ModifiedDate]) VALUES (N'295847284', N'adventure-works\ken0', N'/1/', N'Chief Executive Officer', '1969-01-29', N'S', N'M', '2009-01-14', 99, 1, '2014-06-30 00:00:00.000');
