-- ============================================================================
-- Converted SQL Statements Catalog (PostgreSQL) - COMPLETE
-- Source: BobsBookstore .NET Application + Database Scripts
-- Conversion Date: 2026-03-05
-- Re-processed Date: 2026-03-05 (All statements re-processed through DMS)
-- Tool: DMS MCP (dms-mcp___statement_conversion_tool)
-- Total Statements: 8 (5 from application code + 3 from database scripts)
-- All 8 statements re-processed through DMS with database_name=BobsUsedBookStore
-- ============================================================================

-- =============================================
-- APPLICATION CODE SQL STATEMENTS (5)
-- =============================================

-- Statement 1: EditUsingStoredProcedure
-- Conversion Method: DMS_TOOL
-- DMS: Compound DECLARE/EXEC/SELECT failed ("Statement definition is not valid"). Core EXEC succeeded via sql-conversion-1772746334.
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Input (core EXEC): EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql
-- Conversion Method: DMS_TOOL
-- DMS Status: Success. Metadata model: sql-conversion-1772746419
-- Original: SELECT * FROM Author
SELECT * FROM bobsusedbookstore_dbo.author;

-- Statement 3: DeleteAuthorEmbeddedSql
-- Conversion Method: DMS_TOOL
-- DMS: Compound DECLARE/EXEC/SELECT failed ("Statement definition is not valid"). Core EXEC succeeded via sql-conversion-1772746524.
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Input (core EXEC): EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear
-- Conversion Method: DMS_TOOL (GenAI-assisted)
-- DMS Status: Success. Metadata model: sql-conversion-1772746607
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Note: DMS output uses "HireDate" without @ prefix. In C# code, @HireDate is preserved for NpgsqlParameter binding.
SELECT businessentityid, to_char(modifieddate, 'yyyy-MM-dd HH24:MI:SS') AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;

-- Statement 5: FindAllProducts
-- Conversion Method: DMS_TOOL
-- DMS Status: Success. Metadata model: sql-conversion-1772746690
-- Original: EXEC [dbo].[uspGetProductData];
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);

-- =============================================
-- DATABASE SCRIPT SQL STATEMENTS (3)
-- =============================================

-- Statement 6: CREATE TABLE Author
-- Conversion Method: DMS_TOOL
-- DMS Status: Success. Metadata model: sql-conversion-1772746774
-- Original: CREATE TABLE [dbo].[Author]( [BusinessEntityID] INT IDENTITY(1, 1) NOT NULL, [NationalIDNumber] nvarchar(15) NOT NULL, [LoginID] nvarchar(256) NOT NULL, [OrganizationNode] nvarchar(50) NULL, [JobTitle] nvarchar(50) NOT NULL, [BirthDate] date NOT NULL, [MaritalStatus] nchar(1) NOT NULL, [Gender] nchar(1) NOT NULL, [HireDate] date NOT NULL, [VacationHours] smallint NOT NULL DEFAULT ((0)), [CurrentFlag] bit NOT NULL DEFAULT ((1)), [ModifiedDate] datetime NOT NULL DEFAULT (getdate()) ) ON [PRIMARY];
CREATE TABLE bobsusedbookstore_dbo.author (businessentityid BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL, nationalidnumber VARCHAR(15) NOT NULL, loginid VARCHAR(256) NOT NULL, organizationnode VARCHAR(50) NULL, jobtitle VARCHAR(50) NOT NULL, birthdate DATE NOT NULL, maritalstatus CHAR(1) NOT NULL, gender CHAR(1) NOT NULL, hiredate DATE NOT NULL, vacationhours SMALLINT NOT NULL DEFAULT ((0)), currentflag NUMERIC(1, 0) NOT NULL DEFAULT ((1)), modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (clock_timestamp()));

-- Statement 7: CREATE TABLE Product
-- Conversion Method: DMS_TOOL
-- DMS Status: Success. Metadata model: sql-conversion-1772746858
-- Original: CREATE TABLE [dbo].[Product]( [ProductID] int IDENTITY(1, 1) NOT NULL, [Name] nvarchar(50) NOT NULL, [ProductNumber] nvarchar(25) NOT NULL, [MakeFlag] bit NOT NULL DEFAULT ((1)), [FinishedGoodsFlag] bit NOT NULL DEFAULT ((1)), [Color] nvarchar(15) NULL, [SafetyStockLevel] smallint NOT NULL, [ReorderPoint] smallint NOT NULL, [StandardCost] money NOT NULL, [ListPrice] money NOT NULL, [Size] nvarchar(5) NULL, [SizeUnitMeasureCode] nchar(3) NULL, [WeightUnitMeasureCode] nchar(3) NULL, [Weight] decimal(8,2) NULL, [DaysToManufacture] int NOT NULL, [ProductLine] nchar(2) NULL, [Class] nchar(2) NULL, [Style] nchar(2) NULL, [ProductSubcategoryID] int NULL, [ProductModelID] int NULL, [SellStartDate] datetime NOT NULL, [SellEndDate] datetime NULL, [DiscontinuedDate] datetime NULL, [rowguid] uniqueidentifier NOT NULL DEFAULT (newid()), [ModifiedDate] datetime NOT NULL DEFAULT (getdate()) ) ON [PRIMARY];
CREATE TABLE bobsusedbookstore_dbo.product (productid BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL, name VARCHAR(50) NOT NULL, productnumber VARCHAR(25) NOT NULL, makeflag NUMERIC(1, 0) NOT NULL DEFAULT ((1)), finishedgoodsflag NUMERIC(1, 0) NOT NULL DEFAULT ((1)), color VARCHAR(15) NULL, safetystocklevel SMALLINT NOT NULL, reorderpoint SMALLINT NOT NULL, standardcost NUMERIC(19, 4) NOT NULL, listprice NUMERIC(19, 4) NOT NULL, size VARCHAR(5) NULL, sizeunitmeasurecode CHAR(3) NULL, weightunitmeasurecode CHAR(3) NULL, weight NUMERIC(8, 2) NULL, daystomanufacture INTEGER NOT NULL, productline CHAR(2) NULL, class CHAR(2) NULL, style CHAR(2) NULL, productsubcategoryid INTEGER NULL, productmodelid INTEGER NULL, sellstartdate TIMESTAMP WITHOUT TIME ZONE NOT NULL, sellenddate TIMESTAMP WITHOUT TIME ZONE NULL, discontinueddate TIMESTAMP WITHOUT TIME ZONE NULL, rowguid UUID NOT NULL DEFAULT (aws_sqlserver_ext.newid()), modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (clock_timestamp()));

-- Statement 8: INSERT INTO Author (representative sample)
-- Conversion Method: DMS_TOOL
-- DMS Status: Success. Metadata model: sql-conversion-1772746943
-- Original: INSERT INTO [dbo].[Author] ([NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], [Gender], [HireDate], [VacationHours], [CurrentFlag], [ModifiedDate]) VALUES (N'295847284', N'adventure-works\ken0', N'/1/', N'Chief Executive Officer', '1969-01-29', N'S', N'M', '2009-01-14', 99, 1, '2014-06-30 00:00:00.000');
INSERT INTO bobsusedbookstore_dbo.author (nationalidnumber, loginid, organizationnode, jobtitle, birthdate, maritalstatus, gender, hiredate, vacationhours, currentflag, modifieddate) VALUES ('295847284', E'adventure-works\\ken0', '/1/', 'Chief Executive Officer', '1969-01-29', 'S', 'M', '2009-01-14', 99, 1, '2014-06-30 00:00:00.000');
