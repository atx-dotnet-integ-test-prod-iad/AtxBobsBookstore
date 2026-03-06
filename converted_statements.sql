-- ============================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Target: PostgreSQL (Converted Statements)
-- Migration: SQL Server to PostgreSQL
-- Generated: 2026-03-06
-- All 12 statements attempted DMS conversion - all failed
-- Manual conversion applied with lowercase schema object names
-- ============================================================

-- ============================================================
-- Source File: AuthorsController.cs
-- ============================================================

-- Statement 1: EditUsingStoredProcedure
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:45:49.014059
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
SELECT * FROM dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:46:13.187584
-- Original: SELECT * FROM bobsbookstore_dbo.author
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:46:36.729440
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
SELECT * FROM dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:47:02.211810
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================
-- Source File: ProductsController.cs
-- ============================================================

-- Statement 5: FindAllProducts
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:47:25.524391
-- Original: EXEC [dbo].[uspGetProductData];
SELECT * FROM dbo.uspgetproductdata();

-- ============================================================
-- Source File: db/bobsusedbooks.sql
-- ============================================================

-- Statement 6: CREATE TABLE Members
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:47:50.685818
-- Original: CREATE TABLE [dbo].[Members]([MemberID] INT IDENTITY(1,1) NOT NULL, [FirstName] nvarchar(100) NOT NULL, [LastName] nvarchar(100) NOT NULL, [Email] nvarchar(200) NOT NULL, [MembershipDate] datetime NOT NULL DEFAULT (getdate()), [MembershipLevel] nvarchar(20) NOT NULL DEFAULT 'Bronze');
CREATE TABLE dbo.members(memberid INT GENERATED ALWAYS AS IDENTITY NOT NULL, firstname varchar(100) NOT NULL, lastname varchar(100) NOT NULL, email varchar(200) NOT NULL, membershipdate timestamp NOT NULL DEFAULT NOW(), membershiplevel varchar(20) NOT NULL DEFAULT 'Bronze');

-- Statement 7: CREATE VIEW VwTopMembers
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:48:17.886726
-- Original: CREATE VIEW [dbo].[VwTopMembers] AS SELECT m.MemberID, m.FirstName, m.LastName, m.Email, m.MembershipLevel, COUNT(s.ShoppingID) AS TotalPurchases, SUM(s.TotalAmount) AS TotalSpent FROM [dbo].[Members] m INNER JOIN [dbo].[Shopping] s ON m.MemberID = s.MemberID GROUP BY m.MemberID, m.FirstName, m.LastName, m.Email, m.MembershipLevel HAVING COUNT(s.ShoppingID) > 5;
CREATE VIEW dbo.vwtopmembers AS SELECT m.memberid, m.firstname, m.lastname, m.email, m.membershiplevel, COUNT(s.shoppingid) AS totalpurchases, SUM(s.totalamount) AS totalspent FROM dbo.members m INNER JOIN dbo.shopping s ON m.memberid = s.memberid GROUP BY m.memberid, m.firstname, m.lastname, m.email, m.membershiplevel HAVING COUNT(s.shoppingid) > 5;

-- Statement 8: CREATE FUNCTION ufnGetAccountingEndDate
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:48:41.406829
-- Original: CREATE FUNCTION [dbo].[ufnGetAccountingEndDate]() RETURNS datetime AS BEGIN RETURN DATEADD(millisecond, -2, CONVERT(datetime, '20040701', 112)); END;
CREATE OR REPLACE FUNCTION dbo.ufngetaccountingenddate() RETURNS timestamp AS $$ BEGIN RETURN CAST('2004-07-01' AS timestamp) - INTERVAL '2 milliseconds'; END; $$ LANGUAGE plpgsql;

-- ============================================================
-- Source File: db/adven.sql
-- ============================================================

-- Statement 9: CREATE TABLE Author
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:49:06.523668
-- Original: CREATE TABLE [dbo].[Author]([BusinessEntityID] INT IDENTITY(1, 1) NOT NULL, [NationalIDNumber] nvarchar(15) NOT NULL, [LoginID] nvarchar(256) NOT NULL, [OrganizationNode] nvarchar(50) NULL, [JobTitle] nvarchar(50) NOT NULL, [BirthDate] date NOT NULL, [MaritalStatus] nchar(1) NOT NULL, [Gender] nchar(1) NOT NULL, [HireDate] date NOT NULL, [VacationHours] smallint NOT NULL DEFAULT ((0)), [CurrentFlag] bit NOT NULL DEFAULT ((1)), [ModifiedDate] datetime NOT NULL DEFAULT (getdate()));
CREATE TABLE dbo.author(businessentityid INT GENERATED ALWAYS AS IDENTITY NOT NULL, nationalidnumber varchar(15) NOT NULL, loginid varchar(256) NOT NULL, organizationnode varchar(50) NULL, jobtitle varchar(50) NOT NULL, birthdate date NOT NULL, maritalstatus char(1) NOT NULL, gender char(1) NOT NULL, hiredate date NOT NULL, vacationhours smallint NOT NULL DEFAULT 0, currentflag boolean NOT NULL DEFAULT true, modifieddate timestamp NOT NULL DEFAULT NOW());

-- Statement 10: ALTER TABLE Author ADD CONSTRAINT
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:49:30.350622
-- Original: ALTER TABLE [dbo].[Author] ADD CONSTRAINT [CK_Author_BirthDate] CHECK (([BirthDate]>='1930-01-01' AND [BirthDate]<=dateadd(year,(-18),getdate())));
ALTER TABLE dbo.author ADD CONSTRAINT ck_author_birthdate CHECK ((birthdate>='1930-01-01' AND birthdate<=NOW() - INTERVAL '18 years'));

-- Statement 11: CREATE PROCEDURE uspGetProductData
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:49:54.786804
-- Original: CREATE PROCEDURE [dbo].[uspGetProductData] AS BEGIN SET NOCOUNT ON; SELECT ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, Weight, ProductLine, Class, Style, SellStartDate, SellEndDate, ModifiedDate FROM [dbo].[Product]; END;
CREATE OR REPLACE FUNCTION dbo.uspgetproductdata() RETURNS TABLE(productid INT, name varchar, productnumber varchar, color varchar, standardcost numeric, listprice numeric, size varchar, weight numeric, productline varchar, class varchar, style varchar, sellstartdate timestamp, sellenddate timestamp, modifieddate timestamp) AS $$ BEGIN RETURN QUERY SELECT productid, name, productnumber, color, standardcost, listprice, size, weight, productline, class, style, sellstartdate, sellenddate, modifieddate FROM dbo.product; END; $$ LANGUAGE plpgsql;

-- ============================================================
-- Source File: db/adven-data.sql
-- ============================================================

-- Statement 12: INSERT INTO Author
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-06T13:50:20.056841
-- Original: INSERT INTO [dbo].[Author] ([NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], [Gender], [HireDate], [VacationHours], [CurrentFlag], [ModifiedDate]) VALUES ('295847284', 'adventure-works\ken0', '/', 'Chief Executive Officer', '1969-01-29', 'S', 'M', '2009-01-14', 99, 1, '2014-06-30');
INSERT INTO dbo.author (nationalidnumber, loginid, organizationnode, jobtitle, birthdate, maritalstatus, gender, hiredate, vacationhours, currentflag, modifieddate) VALUES ('295847284', 'adventure-works\ken0', '/', 'Chief Executive Officer', '1969-01-29', 'S', 'M', '2009-01-14', 99, true, '2014-06-30');
