-- Extracted SQL Statements Catalog (Original MS SQL Server)
-- Source: Microsoft SQL Server to PostgreSQL Migration
-- Generated during transformation process
-- Total C# Code Statements: 5
-- Total SQL Script Objects: 50+ (tables, procedures, functions, views, triggers, data inserts)

-- ============================================================
-- C# CODE STATEMENTS (Original MS SQL Server)
-- ============================================================

-- Source: AuthorsController.cs - FindAllAuthorsEmbeddedSql
-- Statement 1:
SELECT * FROM Author;

-- Source: AuthorsController.cs - EditUsingStoredProcedure
-- Statement 2:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Source: AuthorsController.cs - DeleteAuthorEmbeddedSql
-- Statement 3:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Source: AuthorsController.cs - SelectAuthorsByHireYear
-- Statement 4:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Source: ProductsController.cs - FindAllProducts
-- Statement 5:
EXEC [dbo].[uspGetProductData];

-- ============================================================
-- SQL SCRIPT OBJECTS (from db/adven.sql)
-- ============================================================

-- Tables: Author, Person, BillOfMaterials, Product, ErrorLog, DatabaseLog, Members, Shopping, Coupons, ProductSaleRegions, ProductSales
-- Stored Procedures: uspGetBillOfMaterials, uspGetAuthorManagers, uspGetManagerAuthors, uspGetWhereUsedProductID, uspPrintError, uspLogError, uspUpdateAuthorLogin, uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData, uspGetTopRegion, uspDeleteOldCoupons, uspProcessRefunds, uspShoppingLevelAmount
-- Functions: ufnGetAccountingEndDate, ufnGetAccountingStartDate, ufnGetDocumentStatusText, ufnGetPurchaseOrderStatusText, ufnGetSalesOrderStatusText, ufnLeadingZeros, ufnCalculateCustomerLifetimeValue
-- Views: VwTopMembers, VwOpenCoupons, VwCustomerShopping, VwRegionalSales
-- Trigger: ddlDatabaseTriggerLog

-- ============================================================
-- SQL SCRIPT OBJECTS (from db/adven-data.sql)
-- ============================================================

-- INSERT INTO [dbo].[Author] (NationalIDNumber, LoginID, ...) VALUES (...)
-- INSERT INTO [dbo].[Person] (BusinessEntityID, PersonType, ...) VALUES (...)
-- INSERT INTO [dbo].[BillOfMaterials] (...) VALUES (...)
-- INSERT INTO [dbo].[Product] (...) VALUES (...)

-- ============================================================
-- SQL SCRIPT OBJECTS (from db/bobsusedbooks.sql)
-- ============================================================

-- Tables: Address, Author, BillOfMaterials, Book, Customer, DatabaseLog, ErrorLog, Offer, Order, OrderItem, Person, Product, ProductSaleRegions, ReferenceData, ShoppingCart, ShoppingCartItem, Members, Shopping, Coupons, ProductSales
-- Functions: ufnGetAccountingEndDate, ufnGetAccountingStartDate, ufnGetDocumentStatusText, ufnGetPurchaseOrderStatusText, ufnGetSalesOrderStatusText, ufnLeadingZeros, ufnCalculateCustomerLifetimeValue
-- Views: VwTopMembers, VwOpenCoupons, VwCustomerShopping, VwRegionalSales
-- Stored Procedures (in DatabaseLog INSERTs and at end of file)
-- Data: INSERT INTO DatabaseLog, etc.
