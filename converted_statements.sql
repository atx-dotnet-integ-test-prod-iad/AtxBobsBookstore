-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: Microsoft SQL Server to PostgreSQL Migration
-- Generated during transformation process
-- Conversion methods: DMS_TOOL and DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

-- ============================================================
-- C# CODE STATEMENTS
-- ============================================================

-- Source: AuthorsController.cs - FindAllAuthorsEmbeddedSql
-- Conversion Method: DMS_TOOL
-- DMS Output: SELECT * FROM bobsusedbookstore_dbo.author;
-- Statement 1:
SELECT * FROM bobsusedbookstore_dbo.author;

-- Source: AuthorsController.cs - EditUsingStoredProcedure
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Statement definition is not valid.
-- Statement 2:
SELECT bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Source: AuthorsController.cs - DeleteAuthorEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Statement definition is not valid.
-- Statement 3:
SELECT bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Source: AuthorsController.cs - SelectAuthorsByHireYear
-- Conversion Method: DMS_TOOL
-- DMS Output: SELECT businessentityid, to_char(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;
-- Statement 4:
SELECT businessentityid, to_char(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;

-- Source: ProductsController.cs - FindAllProducts
-- Conversion Method: DMS_TOOL
-- DMS Output: CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
-- Statement 5:
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);

-- ============================================================
-- SQL SCRIPT OBJECTS (from db/adven.sql) - All converted to PostgreSQL
-- ============================================================

-- Tables converted with DMS_TOOL patterns:
-- bobsusedbookstore_dbo.author, bobsusedbookstore_dbo.product, bobsusedbookstore_dbo.errorlog (DMS_TOOL)
-- bobsusedbookstore_dbo.person, bobsusedbookstore_dbo.billofmaterials, bobsusedbookstore_dbo.databaselog,
-- bobsusedbookstore_dbo.members, bobsusedbookstore_dbo.shopping, bobsusedbookstore_dbo.coupons,
-- bobsusedbookstore_dbo.productsaleregions, bobsusedbookstore_dbo.productsales (DMS_FAILURE_MANUAL patterns)

-- Procedures converted:
-- bobsusedbookstore_dbo.uspgetbillofmaterials, bobsusedbookstore_dbo.uspgetauthormanagers,
-- bobsusedbookstore_dbo.uspgetmanagerauthors, bobsusedbookstore_dbo.uspgetwhereusedproductid,
-- bobsusedbookstore_dbo.uspprintError, bobsusedbookstore_dbo.usplogerror,
-- bobsusedbookstore_dbo.uspupdateauthorlogin, bobsusedbookstore_dbo.uspupdateauthorpersonalinfo,
-- bobsusedbookstore_dbo.uspdeleteauthor, bobsusedbookstore_dbo.uspgetproductdata,
-- bobsusedbookstore_dbo.uspgettopregion, bobsusedbookstore_dbo.uspdeleteoldcoupons,
-- bobsusedbookstore_dbo.uspprocessrefunds, bobsusedbookstore_dbo.uspshoppinglevelamount

-- Functions converted:
-- bobsusedbookstore_dbo.ufngetaccountingenddate, bobsusedbookstore_dbo.ufngetaccountingstartdate,
-- bobsusedbookstore_dbo.ufngetdocumentstatustext, bobsusedbookstore_dbo.ufngetpurchaseorderstatustext,
-- bobsusedbookstore_dbo.ufngetsalesorderstatustext, bobsusedbookstore_dbo.ufnleadingzeros,
-- bobsusedbookstore_dbo.ufncalculatecustomerlifetimevalue

-- Views converted:
-- bobsusedbookstore_dbo.vwtopmembers, bobsusedbookstore_dbo.vwopencoupons,
-- bobsusedbookstore_dbo.vwcustomershopping, bobsusedbookstore_dbo.vwregionalsales

-- Trigger: ddlDatabaseTriggerLog (commented out - not supported in PostgreSQL)

-- ============================================================
-- SQL SCRIPT OBJECTS (from db/adven-data.sql) - All converted to PostgreSQL
-- ============================================================

-- INSERT INTO bobsusedbookstore_dbo.author (...) VALUES (...) -- N' prefix removed
-- INSERT INTO bobsusedbookstore_dbo.person (...) VALUES (...) -- Schema lowercased
-- INSERT INTO bobsusedbookstore_dbo.billofmaterials (...) VALUES (...)
-- INSERT INTO bobsusedbookstore_dbo.product (...) VALUES (...)

-- ============================================================
-- SQL SCRIPT OBJECTS (from db/bobsusedbooks.sql) - All converted to PostgreSQL
-- ============================================================

-- All tables, functions, views, procedures, and data inserts converted
-- Schema: [dbo] → bobsusedbookstore_dbo
-- ALTER DATABASE / CREATE DATABASE statements removed (PostgreSQL-specific setup)
-- SET IDENTITY_INSERT commented out (not needed in PostgreSQL)
