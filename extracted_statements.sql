-- ============================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Source: MS SQL Server (Original Statements)
-- Migration: SQL Server to PostgreSQL
-- ============================================================

-- ============================================================
-- Source File: AuthorsController.cs
-- ============================================================

-- Statement 1: EditUsingStoredProcedure (line 163)
-- Method: EditUsingStoredProcedure
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: FindAllAuthorsEmbeddedSql (line 187)
-- Method: FindAllAuthorsEmbeddedSql
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql (line 208)
-- Method: DeleteAuthorEmbeddedSql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear (line 228)
-- Method: SelectAuthorsByHireYear
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================
-- Source File: ProductsController.cs
-- ============================================================

-- Statement 5: FindAllProducts (line 34)
-- Method: FindAllProducts
EXEC [dbo].[uspGetProductData];

-- ============================================================
-- Source File: db/bobsusedbooks.sql
-- ============================================================

-- Statement 6: CREATE TABLE Members (bobsusedbooks.sql)
CREATE TABLE [dbo].[Members]([MemberID] INT IDENTITY(1,1) NOT NULL, [FirstName] nvarchar(100) NOT NULL, [LastName] nvarchar(100) NOT NULL, [Email] nvarchar(200) NOT NULL, [MembershipDate] datetime NOT NULL DEFAULT (getdate()), [MembershipLevel] nvarchar(20) NOT NULL DEFAULT 'Bronze');

-- Statement 7: CREATE VIEW VwTopMembers (bobsusedbooks.sql)
CREATE VIEW [dbo].[VwTopMembers] AS SELECT m.MemberID, m.FirstName, m.LastName, m.Email, m.MembershipLevel, COUNT(s.ShoppingID) AS TotalPurchases, SUM(s.TotalAmount) AS TotalSpent FROM [dbo].[Members] m INNER JOIN [dbo].[Shopping] s ON m.MemberID = s.MemberID GROUP BY m.MemberID, m.FirstName, m.LastName, m.Email, m.MembershipLevel HAVING COUNT(s.ShoppingID) > 5;

-- Statement 8: CREATE FUNCTION ufnGetAccountingEndDate (bobsusedbooks.sql)
CREATE FUNCTION [dbo].[ufnGetAccountingEndDate]() RETURNS datetime AS BEGIN RETURN DATEADD(millisecond, -2, CONVERT(datetime, '20040701', 112)); END;

-- ============================================================
-- Source File: db/adven.sql
-- ============================================================

-- Statement 9: CREATE TABLE Author (adven.sql)
CREATE TABLE [dbo].[Author]([BusinessEntityID] INT IDENTITY(1, 1) NOT NULL, [NationalIDNumber] nvarchar(15) NOT NULL, [LoginID] nvarchar(256) NOT NULL, [OrganizationNode] nvarchar(50) NULL, [JobTitle] nvarchar(50) NOT NULL, [BirthDate] date NOT NULL, [MaritalStatus] nchar(1) NOT NULL, [Gender] nchar(1) NOT NULL, [HireDate] date NOT NULL, [VacationHours] smallint NOT NULL DEFAULT ((0)), [CurrentFlag] bit NOT NULL DEFAULT ((1)), [ModifiedDate] datetime NOT NULL DEFAULT (getdate()));

-- Statement 10: ALTER TABLE Author ADD CONSTRAINT (adven.sql)
ALTER TABLE [dbo].[Author] ADD CONSTRAINT [CK_Author_BirthDate] CHECK (([BirthDate]>='1930-01-01' AND [BirthDate]<=dateadd(year,(-18),getdate())));

-- Statement 11: CREATE PROCEDURE uspGetProductData (adven.sql)
CREATE PROCEDURE [dbo].[uspGetProductData] AS BEGIN SET NOCOUNT ON; SELECT ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, Weight, ProductLine, Class, Style, SellStartDate, SellEndDate, ModifiedDate FROM [dbo].[Product]; END;

-- ============================================================
-- Source File: db/adven-data.sql
-- ============================================================

-- Statement 12: INSERT INTO Author (adven-data.sql)
INSERT INTO [dbo].[Author] ([NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], [Gender], [HireDate], [VacationHours], [CurrentFlag], [ModifiedDate]) VALUES ('295847284', 'adventure-works\ken0', '/', 'Chief Executive Officer', '1969-01-29', 'S', 'M', '2009-01-14', 99, 1, '2014-06-30');
