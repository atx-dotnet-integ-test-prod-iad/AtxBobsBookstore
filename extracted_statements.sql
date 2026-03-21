-- =============================================================================
-- Extracted SQL Statements Catalog
-- Source: AuthorsController.cs
-- Migration: MS SQL Server to PostgreSQL
-- =============================================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs, line ~167)
-- Original MS SQL Server stored procedure call
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs, line ~189)
-- Original MS SQL Server SELECT statement
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs, line ~215)
-- Original MS SQL Server stored procedure call
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs, line ~232)
-- Original SELECT with PostgreSQL-style functions (already partially converted)
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;


-- =============================================================================
-- Database Script Extracted SQL Statements
-- Source files: db/bobsusedbooks.sql, db/adven.sql, db/adven-data.sql
-- =============================================================================

-- DB Statement 1: TYPE AccountNumber (db/bobsusedbooks.sql)
CREATE TYPE [dbo].[AccountNumber] FROM [nvarchar](30) NULL;

-- DB Statement 2: TYPE Flag (db/bobsusedbooks.sql)
CREATE TYPE [dbo].[Flag] FROM [bit] NOT NULL;

-- DB Statement 3: TYPE Name (db/bobsusedbooks.sql)
CREATE TYPE [dbo].[Name] FROM [nvarchar](100) NULL;

-- DB Statement 4: TYPE NameStyle (db/bobsusedbooks.sql)
CREATE TYPE [dbo].[NameStyle] FROM [bit] NOT NULL;

-- DB Statement 5: TYPE OrderNumber (db/bobsusedbooks.sql)
CREATE TYPE [dbo].[OrderNumber] FROM [nvarchar](50) NULL;

-- DB Statement 6: TYPE Phone (db/bobsusedbooks.sql)
CREATE TYPE [dbo].[Phone] FROM [nvarchar](50) NULL;

-- DB Statement 7: TABLE Members (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[Members](
    [MemberID] [int] IDENTITY(1,1) NOT NULL,
    [FirstName] [nvarchar](50) NOT NULL,
    [LastName] [nvarchar](50) NOT NULL,
    [Email] [nvarchar](100) NOT NULL,
    [MembershipLevel] [nvarchar](20) NOT NULL,
    [JoinDate] [date] NOT NULL,
    [TotalSpent] [decimal](10, 2) NOT NULL,
    CONSTRAINT [PK_Members] PRIMARY KEY ([MemberID]));

-- DB Statement 8: TABLE Author (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[Author](
    [BusinessEntityID] [int] IDENTITY(1,1) NOT NULL,
    [NationalIDNumber] [nvarchar](15) NOT NULL,
    [LoginID] [nvarchar](256) NOT NULL,
    [OrganizationNode] [nvarchar](50) NULL,
    [JobTitle] [nvarchar](50) NOT NULL,
    [BirthDate] [date] NOT NULL,
    [MaritalStatus] [nchar](1) NOT NULL,
    [Gender] [nchar](1) NOT NULL,
    [HireDate] [date] NOT NULL,
    [VacationHours] [smallint] NOT NULL,
    [CurrentFlag] [dbo].[Flag] NOT NULL,
    [ModifiedDate] [datetime] NOT NULL,
    CONSTRAINT [PK_Author_BusinessEntityID] PRIMARY KEY ([BusinessEntityID]));

-- DB Statement 9: TABLE Product (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[Product](
    [ProductID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [dbo].[Name] NOT NULL,
    [ProductNumber] [nvarchar](25) NOT NULL,
    [MakeFlag] [dbo].[Flag] NOT NULL,
    [FinishedGoodsFlag] [dbo].[Flag] NOT NULL,
    [Color] [nvarchar](15) NULL,
    [SafetyStockLevel] [smallint] NOT NULL,
    [ReorderPoint] [smallint] NOT NULL,
    [StandardCost] [money] NOT NULL,
    [ListPrice] [money] NOT NULL,
    [Size] [nvarchar](5) NULL,
    [SizeUnitMeasureCode] [nchar](3) NULL,
    [WeightUnitMeasureCode] [nchar](3) NULL,
    [Weight] [decimal](8, 2) NULL,
    [DaysToManufacture] [int] NOT NULL,
    [ProductLine] [nchar](2) NULL,
    [Class] [nchar](2) NULL,
    [Style] [nchar](2) NULL,
    [SellStartDate] [datetime] NOT NULL,
    [SellEndDate] [datetime] NULL,
    [DiscontinuedDate] [datetime] NULL,
    [ModifiedDate] [datetime] NOT NULL,
    CONSTRAINT [PK_Product_ProductID] PRIMARY KEY ([ProductID]));

-- DB Statement 10: TABLE BillOfMaterials (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[BillOfMaterials]([BillOfMaterialsID] [int] IDENTITY(1,1) NOT NULL, [ProductAssemblyID] [int] NULL, [ComponentID] [int] NOT NULL, [StartDate] [datetime] NOT NULL, [EndDate] [datetime] NULL, [UnitMeasureCode] [nchar](3) NOT NULL, [BOMLevel] [smallint] NOT NULL, [PerAssemblyQty] [decimal](8, 2) NOT NULL, [ModifiedDate] [datetime] NOT NULL, CONSTRAINT [PK_BillOfMaterials_BillOfMaterialsID] PRIMARY KEY ([BillOfMaterialsID]));

-- DB Statement 11: TABLE Book (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[Book]([BookID] [int] IDENTITY(1,1) NOT NULL, [Title] [nvarchar](200) NOT NULL, [Author] [nvarchar](100) NOT NULL, [ISBN] [nvarchar](20) NOT NULL, [Price] [money] NOT NULL, [Publisher] [nvarchar](100) NOT NULL, [PublishedDate] [date] NOT NULL, [Genre] [nvarchar](50) NOT NULL, [Condition] [nvarchar](20) NOT NULL, [Quantity] [int] NOT NULL, [ModifiedDate] [datetime] NOT NULL, CONSTRAINT [PK_Book_BookID] PRIMARY KEY ([BookID]));

-- DB Statement 12: TABLE Customer (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[Customer]([CustomerID] [int] IDENTITY(1,1) NOT NULL, [PersonID] [int] NOT NULL, [AccountNumber] [nvarchar](30) NOT NULL, [ModifiedDate] [datetime] NOT NULL, CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY ([CustomerID]));

-- DB Statement 13: TABLE DatabaseLog (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[DatabaseLog]([DatabaseLogID] [int] IDENTITY(1,1) NOT NULL, [PostTime] [datetime] NOT NULL, [DatabaseUser] [nvarchar](128) NOT NULL, [Event] [nvarchar](128) NOT NULL, [Schema] [nvarchar](128) NULL, [Object] [nvarchar](128) NULL, [TSQL] [nvarchar](max) NOT NULL, [XmlEvent] [nvarchar](max) NOT NULL, CONSTRAINT [PK_DatabaseLog_DatabaseLogID] PRIMARY KEY ([DatabaseLogID]));

-- DB Statement 14: TABLE ErrorLog (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[ErrorLog]([ErrorLogID] [int] IDENTITY(1,1) NOT NULL, [ErrorTime] [datetime] NOT NULL, [UserName] [nvarchar](128) NOT NULL, [ErrorNumber] [int] NOT NULL, [ErrorSeverity] [int] NULL, [ErrorState] [int] NULL, [ErrorProcedure] [nvarchar](126) NULL, [ErrorLine] [int] NULL, [ErrorMessage] [nvarchar](4000) NOT NULL, CONSTRAINT [PK_ErrorLog_ErrorLogID] PRIMARY KEY ([ErrorLogID]));

-- DB Statement 15: TABLE Address (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[Address]([AddressID] [int] IDENTITY(1,1) NOT NULL, [AddressLine1] [nvarchar](60) NOT NULL, [AddressLine2] [nvarchar](60) NULL, [City] [nvarchar](30) NOT NULL, [StateProvince] [nvarchar](50) NOT NULL, [PostalCode] [nvarchar](15) NOT NULL, [ModifiedDate] [datetime] NOT NULL, CONSTRAINT [PK_Address_AddressID] PRIMARY KEY ([AddressID]));

-- DB Statement 16: TABLE Offer (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[Offer]([OfferID] [int] IDENTITY(1,1) NOT NULL, [BookID] [int] NOT NULL, [CustomerID] [int] NOT NULL, [OfferPrice] [money] NOT NULL, [Condition] [nvarchar](20) NOT NULL, [Publisher] [nvarchar](100) NOT NULL, [BookType] [nvarchar](50) NOT NULL, [OfferDate] [datetime] NOT NULL, [Status] [nvarchar](20) NOT NULL, [ModifiedDate] [datetime] NOT NULL, CONSTRAINT [PK_Offer_OfferID] PRIMARY KEY ([OfferID]));

-- DB Statement 17: TABLE Order (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[Order]([OrderID] [int] IDENTITY(1,1) NOT NULL, [CustomerID] [int] NOT NULL, [AddressID] [int] NOT NULL, [OrderDate] [datetime] NOT NULL, [TotalPrice] [money] NOT NULL, [Status] [nvarchar](20) NOT NULL, [ModifiedDate] [datetime] NOT NULL, CONSTRAINT [PK_Order_OrderID] PRIMARY KEY ([OrderID]));

-- DB Statement 18: TABLE OrderItem (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[OrderItem]([OrderItemID] [int] IDENTITY(1,1) NOT NULL, [OrderID] [int] NOT NULL, [BookID] [int] NOT NULL, [Quantity] [int] NOT NULL, [Price] [money] NOT NULL, [ModifiedDate] [datetime] NOT NULL, CONSTRAINT [PK_OrderItem_OrderItemID] PRIMARY KEY ([OrderItemID]));

-- DB Statement 19: TABLE Person (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[Person]([PersonID] [int] IDENTITY(1,1) NOT NULL, [PersonType] [nchar](2) NOT NULL, [NameStyle] [dbo].[NameStyle] NOT NULL, [Title] [nvarchar](8) NULL, [FirstName] [dbo].[Name] NOT NULL, [MiddleName] [dbo].[Name] NULL, [LastName] [dbo].[Name] NOT NULL, [Suffix] [nvarchar](10) NULL, [EmailPromotion] [int] NOT NULL, [ModifiedDate] [datetime] NOT NULL, CONSTRAINT [PK_Person_PersonID] PRIMARY KEY ([PersonID]));

-- DB Statement 20: TABLE Shopping (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[Shopping]([ShoppingID] [int] IDENTITY(1,1) NOT NULL, [CustomerID] [int] NOT NULL, [OrderDate] [date] NOT NULL, [TotalAmount] [decimal](10, 2) NOT NULL, [Status] [nvarchar](50) NOT NULL, [ShippingAddress] [nvarchar](200) NOT NULL, [PaymentMethod] [nvarchar](50) NOT NULL, [CreatedAt] [datetime2] NOT NULL, [UpdatedAt] [datetime2] NOT NULL, CONSTRAINT [PK_Shopping] PRIMARY KEY ([ShoppingID]));

-- DB Statement 21: TABLE Coupons (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[Coupons]([CouponID] [int] IDENTITY(1,1) NOT NULL, [CouponCode] [nvarchar](20) NOT NULL, [DiscountPercent] [decimal](5, 2) NOT NULL, [ExpirationDate] [date] NOT NULL, [IsActive] [bit] NOT NULL, [CreatedDate] [datetime2] NOT NULL, [MaxUses] [int] NOT NULL, [CurrentUses] [int] NOT NULL, CONSTRAINT [PK_Coupons] PRIMARY KEY ([CouponID]));

-- DB Statement 22: TABLE ProductSaleRegions (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[ProductSaleRegions]([RegionID] [int] IDENTITY(1,1) NOT NULL, [RegionName] [nvarchar](50) NOT NULL, CONSTRAINT [PK_ProductSaleRegions] PRIMARY KEY ([RegionID]));

-- DB Statement 23: TABLE ProductSales (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[ProductSales]([SaleID] [int] IDENTITY(1,1) NOT NULL, [ProductID] [int] NOT NULL, [RegionID] [int] NOT NULL, [SaleDate] [date] NOT NULL, [Quantity] [int] NOT NULL, [UnitPrice] [decimal](10, 2) NOT NULL, [TotalAmount] [decimal](10, 2) NOT NULL, [SalesPersonID] [int] NULL, [Discount] [decimal](5, 2) NULL, CONSTRAINT [PK_ProductSales] PRIMARY KEY ([SaleID]));

-- DB Statement 24: TABLE ReferenceData (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[ReferenceData]([ReferenceDataID] [int] IDENTITY(1,1) NOT NULL, [Type] [nvarchar](50) NOT NULL, [Text] [nvarchar](200) NOT NULL, [OrderIndex] [int] NOT NULL, [Active] [bit] NOT NULL, [ModifiedDate] [datetime] NOT NULL, CONSTRAINT [PK_ReferenceData_ReferenceDataID] PRIMARY KEY ([ReferenceDataID]));

-- DB Statement 25: TABLE ShoppingCart (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[ShoppingCart]([ShoppingCartID] [int] IDENTITY(1,1) NOT NULL, [CustomerID] [int] NOT NULL, [DateCreated] [datetime] NOT NULL, [ModifiedDate] [datetime] NOT NULL, CONSTRAINT [PK_ShoppingCart_ShoppingCartID] PRIMARY KEY ([ShoppingCartID]));

-- DB Statement 26: TABLE ShoppingCartItem (db/bobsusedbooks.sql)
CREATE TABLE [dbo].[ShoppingCartItem]([ShoppingCartItemID] [int] IDENTITY(1,1) NOT NULL, [ShoppingCartID] [int] NOT NULL, [BookID] [int] NOT NULL, [Quantity] [int] NOT NULL, [DateCreated] [datetime] NOT NULL, [ModifiedDate] [datetime] NOT NULL, CONSTRAINT [PK_ShoppingCartItem_ShoppingCartItemID] PRIMARY KEY ([ShoppingCartItemID]));

-- DB Statement 27: FUNCTION ufnCalculateCustomerLifetimeValue (db/bobsusedbooks.sql)
CREATE FUNCTION [dbo].[ufnCalculateCustomerLifetimeValue](@CustomerID INT) RETURNS DECIMAL(10, 2) AS BEGIN DECLARE @TotalSpent DECIMAL(10, 2); DECLARE @FirstOrderDate DATE; DECLARE @DaysSinceFirstOrder INT; DECLARE @LifetimeValue DECIMAL(10, 2); SELECT @TotalSpent = SUM([TotalAmount]), @FirstOrderDate = MIN([OrderDate]) FROM [dbo].[Shopping] WHERE [CustomerID] = @CustomerID AND TRIM([Status]) != 'Refund Requested'; SET @DaysSinceFirstOrder = DATEDIFF(DAY, @FirstOrderDate, GETDATE()); IF @DaysSinceFirstOrder = 0 SET @LifetimeValue = @TotalSpent; ELSE SET @LifetimeValue = (@TotalSpent / @DaysSinceFirstOrder) * 365.25; RETURN @LifetimeValue; END;;

-- DB Statement 28: FUNCTION ufnGetAccountingEndDate (db/bobsusedbooks.sql)
CREATE FUNCTION [dbo].[ufnGetAccountingEndDate]() RETURNS [datetime] AS BEGIN RETURN DATEADD(month, 1, GETDATE()); END;;

-- DB Statement 29: FUNCTION ufnGetAccountingStartDate (db/bobsusedbooks.sql)
CREATE FUNCTION [dbo].[ufnGetAccountingStartDate]() RETURNS [datetime] AS BEGIN RETURN CONVERT(datetime, '20030701', 112); END;;

-- DB Statement 30: FUNCTION ufnGetDocumentStatusText (db/bobsusedbooks.sql)
CREATE FUNCTION [dbo].[ufnGetDocumentStatusText](@Status [tinyint]) RETURNS [nvarchar](16) AS BEGIN DECLARE @ret [nvarchar](16); SET @ret = CASE @Status WHEN 1 THEN N'Pending approval' WHEN 2 THEN N'Approved' WHEN 3 THEN N'Obsolete' ELSE N'** Invalid **' END; RETURN @ret; END;;

-- DB Statement 31: FUNCTION ufnGetPurchaseOrderStatusText (db/bobsusedbooks.sql)
CREATE FUNCTION [dbo].[ufnGetPurchaseOrderStatusText](@Status [tinyint]) RETURNS [nvarchar](15) AS BEGIN DECLARE @ret [nvarchar](15); SET @ret = CASE @Status WHEN 1 THEN N'Pending' WHEN 2 THEN N'Approved' WHEN 3 THEN N'Rejected' WHEN 4 THEN N'Complete' ELSE N'** Invalid **' END; RETURN @ret; END;;

-- DB Statement 32: FUNCTION ufnGetSalesOrderStatusText (db/bobsusedbooks.sql)
CREATE FUNCTION [dbo].[ufnGetSalesOrderStatusText](@Status [tinyint]) RETURNS [nvarchar](15) AS BEGIN DECLARE @ret [nvarchar](15); SET @ret = CASE @Status WHEN 1 THEN N'In process' WHEN 2 THEN N'Approved' WHEN 3 THEN N'Backordered' WHEN 4 THEN N'Rejected' WHEN 5 THEN N'Shipped' WHEN 6 THEN N'Cancelled' ELSE N'** Invalid **' END; RETURN @ret; END;;

-- DB Statement 33: FUNCTION ufnLeadingZeros (db/bobsusedbooks.sql)
CREATE FUNCTION [dbo].[ufnLeadingZeros](@Value int) RETURNS varchar(8) AS BEGIN DECLARE @ReturnValue varchar(8); SET @ReturnValue = CONVERT(varchar(8), @Value); SET @ReturnValue = REPLICATE('0', 8 - DATALENGTH(@ReturnValue)) + @ReturnValue; RETURN (@ReturnValue); END;;

-- DB Statement 34: VIEW VwTopMembers (db/bobsusedbooks.sql)
CREATE VIEW [dbo].[VwTopMembers] AS SELECT [MemberID], [FirstName], [LastName], [Email], [MembershipLevel], [JoinDate], [TotalSpent] FROM [dbo].[Members] WHERE [TotalSpent] > 1000 AND [MembershipLevel] IN ('Gold', 'Platinum');;

-- DB Statement 35: VIEW VwOpenCoupons (db/bobsusedbooks.sql)
CREATE VIEW [dbo].[VwOpenCoupons] AS SELECT [CouponID], [CouponCode], [DiscountPercent], [ExpirationDate], [MaxUses], [CurrentUses], ([MaxUses] - [CurrentUses]) AS [RemainingUses] FROM [dbo].[Coupons] WHERE [IsActive] = 1 AND [ExpirationDate] >= GETDATE();;

-- DB Statement 36: VIEW VwCustomerShopping (db/bobsusedbooks.sql)
CREATE VIEW [dbo].[VwCustomerShopping] AS SELECT s.[ShoppingID], s.[CustomerID], s.[OrderDate], s.[TotalAmount], s.[Status], s.[ShippingAddress], s.[PaymentMethod], m.[FirstName], m.[LastName], m.[MembershipLevel] FROM [dbo].[Shopping] s INNER JOIN [dbo].[Members] m ON s.[CustomerID] = m.[MemberID];;

-- DB Statement 37: VIEW VwRegionalSales (db/bobsusedbooks.sql)
CREATE VIEW [dbo].[VwRegionalSales] ([RegionName], [RegionSalesSum]) AS SELECT r.[RegionName], SUM(ps.[TotalAmount]) AS [RegionSalesSum] FROM [dbo].[ProductSales] ps INNER JOIN [dbo].[ProductSaleRegions] r ON ps.[RegionID] = r.[RegionID] GROUP BY r.[RegionName];;

-- DB Statement 38: STORED_PROCEDURE uspDeleteAuthor (db/bobsusedbooks.sql)
CREATE PROCEDURE [dbo].[uspDeleteAuthor] @BusinessEntityID [int] WITH EXECUTE AS CALLER AS BEGIN SET NOCOUNT ON; BEGIN TRY DELETE FROM [dbo].[Author] WHERE [BusinessEntityID] = @BusinessEntityID; IF @@ROWCOUNT = 0 BEGIN RAISERROR('No author found with the provided BusinessEntityID.', 16, 1); RETURN; END END TRY BEGIN CATCH EXECUTE [dbo].[uspLogError]; THROW; END CATCH; END;;

-- DB Statement 39: STORED_PROCEDURE uspGetAuthorManagers (db/bobsusedbooks.sql)
CREATE PROCEDURE [dbo].[uspGetAuthorManagers] @BusinessEntityID [int] AS BEGIN SET NOCOUNT ON; SELECT [BusinessEntityID], [LoginID], [JobTitle] FROM [dbo].[Author] WHERE [BusinessEntityID] = @BusinessEntityID; END;;

-- DB Statement 40: STORED_PROCEDURE uspGetBillOfMaterials (db/bobsusedbooks.sql)
CREATE PROCEDURE [dbo].[uspGetBillOfMaterials] @StartProductID [int], @CheckDate [datetime] AS BEGIN SET NOCOUNT ON; SELECT [BillOfMaterialsID], [ProductAssemblyID], [ComponentID], [StartDate], [EndDate], [UnitMeasureCode], [BOMLevel], [PerAssemblyQty] FROM [dbo].[BillOfMaterials] WHERE [ProductAssemblyID] = @StartProductID AND @CheckDate >= [StartDate] AND @CheckDate <= ISNULL([EndDate], @CheckDate); END;;

-- DB Statement 41: STORED_PROCEDURE uspGetManagerAuthors (db/bobsusedbooks.sql)
CREATE PROCEDURE [dbo].[uspGetManagerAuthors] @ManagerID [int] AS BEGIN SET NOCOUNT ON; SELECT [BusinessEntityID], [LoginID], [JobTitle] FROM [dbo].[Author]; END;;

-- DB Statement 42: STORED_PROCEDURE uspGetWhereUsedProductID (db/bobsusedbooks.sql)
CREATE PROCEDURE [dbo].[uspGetWhereUsedProductID] @StartProductID [int], @CheckDate [datetime] AS BEGIN SET NOCOUNT ON; SELECT [BillOfMaterialsID], [ProductAssemblyID], [ComponentID], [StartDate], [EndDate], [UnitMeasureCode], [BOMLevel], [PerAssemblyQty] FROM [dbo].[BillOfMaterials] WHERE [ComponentID] = @StartProductID AND @CheckDate >= [StartDate] AND @CheckDate <= ISNULL([EndDate], @CheckDate); END;;

-- DB Statement 43: STORED_PROCEDURE uspPrintError (db/bobsusedbooks.sql)
CREATE PROCEDURE [dbo].[uspPrintError] AS BEGIN SET NOCOUNT ON; PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) + ', Severity ' + CONVERT(varchar(5), ERROR_SEVERITY()) + ', State ' + CONVERT(varchar(5), ERROR_STATE()) + ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') + ', Line ' + CONVERT(varchar(5), ERROR_LINE()); PRINT ERROR_MESSAGE(); END;;

-- DB Statement 44: STORED_PROCEDURE uspLogError (db/bobsusedbooks.sql)
CREATE OR ALTER PROCEDURE [dbo].[uspLogError] @ErrorLogID [int] = 0 OUTPUT AS BEGIN SET NOCOUNT ON; SET @ErrorLogID = 0; BEGIN TRY IF ERROR_NUMBER() IS NULL RETURN; IF XACT_STATE() = -1 RETURN; INSERT [dbo].[ErrorLog] ([UserName], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage]) VALUES (CONVERT(nvarchar(128), CURRENT_USER), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE()); SET @ErrorLogID = @@IDENTITY; END TRY BEGIN CATCH PRINT 'An error occurred in stored procedure uspLogError: '; RETURN -1; END CATCH END;;

-- DB Statement 45: STORED_PROCEDURE uspUpdateAuthorLogin (db/bobsusedbooks.sql)
CREATE PROCEDURE [dbo].[uspUpdateAuthorLogin] @BusinessEntityID [int], @OrganizationNode [nvarchar](50) = NULL, @LoginID [nvarchar](256), @JobTitle [nvarchar](50), @HireDate [datetime], @CurrentFlag [dbo].[Flag] WITH EXECUTE AS CALLER AS BEGIN SET NOCOUNT ON; BEGIN TRY UPDATE [dbo].[Author] SET [OrganizationNode] = @OrganizationNode, [LoginID] = @LoginID, [JobTitle] = @JobTitle, [HireDate] = @HireDate, [CurrentFlag] = @CurrentFlag WHERE [BusinessEntityID] = @BusinessEntityID; END TRY BEGIN CATCH EXECUTE [dbo].[uspLogError]; END CATCH; END;;

-- DB Statement 46: STORED_PROCEDURE uspUpdateAuthorPersonalInfo (db/bobsusedbooks.sql)
CREATE PROCEDURE [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID [int], @NationalIDNumber [nvarchar](15), @BirthDate [datetime], @MaritalStatus [nchar](1), @Gender [nchar](1) WITH EXECUTE AS CALLER AS BEGIN SET NOCOUNT ON; BEGIN TRY UPDATE [dbo].[Author] SET [NationalIDNumber] = @NationalIDNumber, [BirthDate] = @BirthDate, [MaritalStatus] = @MaritalStatus, [Gender] = @Gender WHERE [BusinessEntityID] = @BusinessEntityID; END TRY BEGIN CATCH EXECUTE [dbo].[uspLogError]; END CATCH; END;;

-- DB Statement 47: STORED_PROCEDURE uspGetProductData (db/bobsusedbooks.sql)
CREATE PROCEDURE [dbo].[uspGetProductData] @ProductID [int] AS BEGIN SET NOCOUNT ON; SELECT [ProductID], [Name], [ProductNumber], [ListPrice], [StandardCost] FROM [dbo].[Product] WHERE [ProductID] = @ProductID; END;;

-- DB Statement 48: STORED_PROCEDURE uspGetTopRegion (db/bobsusedbooks.sql)
CREATE PROCEDURE [dbo].[uspGetTopRegion] AS BEGIN SET NOCOUNT ON; SELECT TOP 1 r.[RegionName], SUM(ps.[TotalAmount]) AS TotalSales FROM [dbo].[ProductSales] ps INNER JOIN [dbo].[ProductSaleRegions] r ON ps.[RegionID] = r.[RegionID] GROUP BY r.[RegionName] ORDER BY TotalSales DESC; END;;

-- DB Statement 49: STORED_PROCEDURE uspDeleteOldCoupons (db/bobsusedbooks.sql)
CREATE OR ALTER PROCEDURE [dbo].[uspDeleteOldCoupons] AS BEGIN SET NOCOUNT ON; BEGIN TRY DELETE FROM [dbo].[Coupons] WHERE [ExpirationDate] < GETDATE() AND [IsActive] = 0; END TRY BEGIN CATCH EXECUTE [dbo].[uspLogError]; THROW; END CATCH END;;

-- DB Statement 50: STORED_PROCEDURE uspProcessRefunds (db/bobsusedbooks.sql)
CREATE OR ALTER PROCEDURE [dbo].[uspProcessRefunds] AS BEGIN SET NOCOUNT ON; BEGIN TRY UPDATE [dbo].[Shopping] SET [Status] = 'Refunded', [UpdatedAt] = GETDATE() WHERE TRIM([Status]) = 'Refund Requested'; END TRY BEGIN CATCH EXECUTE [dbo].[uspLogError]; THROW; END CATCH END;;

-- DB Statement 51: STORED_PROCEDURE uspShoppingLevelAmount (db/bobsusedbooks.sql)
CREATE OR ALTER PROCEDURE [dbo].[uspShoppingLevelAmount] @Level NVARCHAR(20) AS BEGIN SET NOCOUNT ON; SELECT m.[MemberID], m.[FirstName], m.[LastName], SUM(s.[TotalAmount]) AS TotalSpent FROM [dbo].[Members] m INNER JOIN [dbo].[Shopping] s ON m.[MemberID] = s.[CustomerID] WHERE m.[MembershipLevel] = @Level GROUP BY m.[MemberID], m.[FirstName], m.[LastName] ORDER BY TotalSpent DESC; END;;

-- DB Statement 52: TRIGGER ddlDatabaseTriggerLog (db/bobsusedbooks.sql)
CREATE TRIGGER [ddlDatabaseTriggerLog] ON DATABASE FOR DDL_DATABASE_LEVEL_EVENTS AS BEGIN SET NOCOUNT ON; DECLARE @data XML; SET @data = EVENTDATA(); INSERT [dbo].[DatabaseLog] ([PostTime], [DatabaseUser], [Event], [Schema], [Object], [TSQL], [XmlEvent]) VALUES (GETDATE(), CONVERT(nvarchar(128), CURRENT_USER), @data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(128)'), @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'nvarchar(128)'), @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(128)'), @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)'), @data); END;;

-- DB Statement 53: INSERT INSERT_Author (db/adven-data.sql)
INSERT [dbo].[Author] ([BusinessEntityID], [NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], [Gender], [HireDate], [VacationHours], [CurrentFlag], [ModifiedDate]) VALUES (1, N'295847284', N'adventure-works\ken0', N'/', N'Chief Executive Officer', CAST(N'1969-01-29' AS Date), N'S', N'M', CAST(N'2009-01-14' AS Date), 99, 1, CAST(N'2025-08-25T02:04:09.597' AS DateTime));

-- DB Statement 54: INSERT INSERT_Person (db/adven-data.sql)
INSERT [dbo].[Person] ([PersonID], [PersonType], [NameStyle], [Title], [FirstName], [MiddleName], [LastName], [Suffix], [EmailPromotion], [ModifiedDate]) VALUES (1, N'EM', 0, NULL, N'Ken', N'J', N'Sanchez', NULL, 0, CAST(N'2025-08-25T02:04:09.597' AS DateTime));

-- DB Statement 55: INSERT INSERT_Customer (db/adven-data.sql)
INSERT [dbo].[Customer] ([CustomerID], [PersonID], [AccountNumber], [ModifiedDate]) VALUES (1, 1, N'AW00000001', CAST(N'2025-08-25T02:04:09.597' AS DateTime));

-- DB Statement 56: INSERT INSERT_Product (db/adven-data.sql)
INSERT [dbo].[Product] ([ProductID], [Name], [ProductNumber], [MakeFlag], [FinishedGoodsFlag], [Color], [SafetyStockLevel], [ReorderPoint], [StandardCost], [ListPrice], [Size], [SizeUnitMeasureCode], [WeightUnitMeasureCode], [Weight], [DaysToManufacture], [ProductLine], [Class], [Style], [SellStartDate], [SellEndDate], [DiscontinuedDate], [ModifiedDate]) VALUES (1, N'Adjustable Race', N'AR-5381', 0, 0, NULL, 1000, 750, 0.0000, 0.0000, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, CAST(N'2008-04-30T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2014-02-08T10:01:36.827' AS DateTime));

-- DB Statement 57: INSERT INSERT_BillOfMaterials (db/adven-data.sql)
INSERT [dbo].[BillOfMaterials] ([BillOfMaterialsID], [ProductAssemblyID], [ComponentID], [StartDate], [EndDate], [UnitMeasureCode], [BOMLevel], [PerAssemblyQty], [ModifiedDate]) VALUES (893, 749, 3, CAST(N'2008-04-30T00:00:00.000' AS DateTime), NULL, N'EA ', 1, CAST(1.00 AS Decimal(8, 2)), CAST(N'2014-02-08T10:01:36.827' AS DateTime));

-- DB Statement 58: INSERT INSERT_Members (db/adven-data.sql)
INSERT [dbo].[Members] ([MemberID], [FirstName], [LastName], [Email], [MembershipLevel], [JoinDate], [TotalSpent]) VALUES (1, N'John', N'Smith', N'john.smith@example.com', N'Gold', CAST(N'2023-01-15' AS Date), CAST(2500.00 AS Decimal(10, 2)));

-- DB Statement 59: INSERT INSERT_Shopping (db/adven-data.sql)
INSERT [dbo].[Shopping] ([ShoppingID], [CustomerID], [OrderDate], [TotalAmount], [Status], [ShippingAddress], [PaymentMethod], [CreatedAt], [UpdatedAt]) VALUES (1, 1, CAST(N'2024-01-15' AS Date), CAST(150.00 AS Decimal(10, 2)), N'Completed', N'123 Main St, City, ST 12345', N'Credit Card', CAST(N'2024-01-15T10:30:00' AS DateTime2), CAST(N'2024-01-15T10:30:00' AS DateTime2));

-- DB Statement 60: INSERT INSERT_ProductSaleRegions (db/adven-data.sql)
INSERT [dbo].[ProductSaleRegions] ([RegionID], [RegionName]) VALUES (1, N'Northeast');

-- DB Statement 61: INSERT INSERT_ProductSales (db/adven-data.sql)
INSERT [dbo].[ProductSales] ([SaleID], [ProductID], [RegionID], [SaleDate], [Quantity], [UnitPrice], [TotalAmount], [SalesPersonID], [Discount]) VALUES (1, 1, 1, CAST(N'2024-01-15' AS Date), 10, CAST(29.99 AS Decimal(10, 2)), CAST(299.90 AS Decimal(10, 2)), 1, CAST(0.00 AS Decimal(5, 2)));


-- Statement 5: ProductsController.cs FindAllProducts (line ~36)
-- Original MS SQL Server stored procedure call
EXEC [dbo].[uspGetProductData];
