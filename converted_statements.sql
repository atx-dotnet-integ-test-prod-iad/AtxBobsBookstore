-- =============================================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: AuthorsController.cs
-- Migration: MS SQL Server to PostgreSQL
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects were found according to the specified selection rules.
-- =============================================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs, line ~167)
-- Converted from MS SQL DECLARE/EXEC to PostgreSQL CALL syntax with lowercase schema
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
CALL bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs, line ~189)
-- Converted from MS SQL SELECT to PostgreSQL SELECT with lowercase schema
-- Original: SELECT * FROM bobsbookstore_dbo.author
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs, line ~215)
-- Converted from MS SQL DECLARE/EXEC to PostgreSQL CALL syntax with lowercase schema
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
CALL bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs, line ~232)
-- Converted to PostgreSQL with lowercase schema (functions already PostgreSQL-compatible)
-- Original: SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;


-- =============================================================================
-- Database Script Converted SQL Statements (PostgreSQL)
-- Source files: db/bobsusedbooks.sql, db/adven.sql, db/adven-data.sql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- =============================================================================

-- DB Statement 1: TYPE AccountNumber (db/bobsusedbooks.sql)
CREATE DOMAIN bobsbookstore_dbo.accountnumber AS VARCHAR(30);

-- DB Statement 2: TYPE Flag (db/bobsusedbooks.sql)
CREATE DOMAIN bobsbookstore_dbo.flag AS BOOLEAN NOT NULL;

-- DB Statement 3: TYPE Name (db/bobsusedbooks.sql)
CREATE DOMAIN bobsbookstore_dbo.name AS VARCHAR(100);

-- DB Statement 4: TYPE NameStyle (db/bobsusedbooks.sql)
CREATE DOMAIN bobsbookstore_dbo.namestyle AS BOOLEAN NOT NULL;

-- DB Statement 5: TYPE OrderNumber (db/bobsusedbooks.sql)
CREATE DOMAIN bobsbookstore_dbo.ordernumber AS VARCHAR(50);

-- DB Statement 6: TYPE Phone (db/bobsusedbooks.sql)
CREATE DOMAIN bobsbookstore_dbo.phone AS VARCHAR(50);

-- DB Statement 7: TABLE Members (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.members(
    memberid SERIAL PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    membershiplevel VARCHAR(20) NOT NULL,
    joindate DATE NOT NULL,
    totalspent DECIMAL(10, 2) NOT NULL);

-- DB Statement 8: TABLE Author (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.author(
    businessentityid SERIAL PRIMARY KEY,
    nationalidnumber VARCHAR(15) NOT NULL,
    loginid VARCHAR(256) NOT NULL,
    organizationnode VARCHAR(50),
    jobtitle VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    maritalstatus CHAR(1) NOT NULL,
    gender CHAR(1) NOT NULL,
    hiredate DATE NOT NULL,
    vacationhours SMALLINT NOT NULL,
    currentflag BOOLEAN NOT NULL,
    modifieddate TIMESTAMP NOT NULL);

-- DB Statement 9: TABLE Product (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.product(
    productid SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    productnumber VARCHAR(25) NOT NULL,
    makeflag BOOLEAN NOT NULL,
    finishedgoodsflag BOOLEAN NOT NULL,
    color VARCHAR(15),
    safetystocklevel SMALLINT NOT NULL,
    reorderpoint SMALLINT NOT NULL,
    standardcost NUMERIC(19,4) NOT NULL,
    listprice NUMERIC(19,4) NOT NULL,
    size VARCHAR(5),
    sizeunitmeasurecode CHAR(3),
    weightunitmeasurecode CHAR(3),
    weight DECIMAL(8, 2),
    daystomanufacture INTEGER NOT NULL,
    productline CHAR(2),
    class CHAR(2),
    style CHAR(2),
    sellstartdate TIMESTAMP NOT NULL,
    sellenddate TIMESTAMP,
    discontinueddate TIMESTAMP,
    modifieddate TIMESTAMP NOT NULL);

-- DB Statement 10: TABLE BillOfMaterials (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.billofmaterials(billofmaterialsid SERIAL PRIMARY KEY, productassemblyid INTEGER, componentid INTEGER NOT NULL, startdate TIMESTAMP NOT NULL, enddate TIMESTAMP, unitmeasurecode CHAR(3) NOT NULL, bomlevel SMALLINT NOT NULL, perassemblyqty DECIMAL(8, 2) NOT NULL, modifieddate TIMESTAMP NOT NULL);

-- DB Statement 11: TABLE Book (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.book(bookid SERIAL PRIMARY KEY, title VARCHAR(200) NOT NULL, author VARCHAR(100) NOT NULL, isbn VARCHAR(20) NOT NULL, price NUMERIC(19,4) NOT NULL, publisher VARCHAR(100) NOT NULL, publisheddate DATE NOT NULL, genre VARCHAR(50) NOT NULL, condition VARCHAR(20) NOT NULL, quantity INTEGER NOT NULL, modifieddate TIMESTAMP NOT NULL);

-- DB Statement 12: TABLE Customer (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.customer(customerid SERIAL PRIMARY KEY, personid INTEGER NOT NULL, accountnumber VARCHAR(30) NOT NULL, modifieddate TIMESTAMP NOT NULL);

-- DB Statement 13: TABLE DatabaseLog (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.databaselog(databaselogid SERIAL PRIMARY KEY, posttime TIMESTAMP NOT NULL, databaseuser VARCHAR(128) NOT NULL, event VARCHAR(128) NOT NULL, schema_name VARCHAR(128), object VARCHAR(128), tsql TEXT NOT NULL, xmlevent TEXT NOT NULL);

-- DB Statement 14: TABLE ErrorLog (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.errorlog(errorlogid SERIAL PRIMARY KEY, errortime TIMESTAMP NOT NULL, username VARCHAR(128) NOT NULL, errornumber INTEGER NOT NULL, errorseverity INTEGER, errorstate INTEGER, errorprocedure VARCHAR(126), errorline INTEGER, errormessage VARCHAR(4000) NOT NULL);

-- DB Statement 15: TABLE Address (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.address(addressid SERIAL PRIMARY KEY, addressline1 VARCHAR(60) NOT NULL, addressline2 VARCHAR(60), city VARCHAR(30) NOT NULL, stateprovince VARCHAR(50) NOT NULL, postalcode VARCHAR(15) NOT NULL, modifieddate TIMESTAMP NOT NULL);

-- DB Statement 16: TABLE Offer (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.offer(offerid SERIAL PRIMARY KEY, bookid INTEGER NOT NULL, customerid INTEGER NOT NULL, offerprice NUMERIC(19,4) NOT NULL, condition VARCHAR(20) NOT NULL, publisher VARCHAR(100) NOT NULL, booktype VARCHAR(50) NOT NULL, offerdate TIMESTAMP NOT NULL, status VARCHAR(20) NOT NULL, modifieddate TIMESTAMP NOT NULL);

-- DB Statement 17: TABLE Order (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo."order"(orderid SERIAL PRIMARY KEY, customerid INTEGER NOT NULL, addressid INTEGER NOT NULL, orderdate TIMESTAMP NOT NULL, totalprice NUMERIC(19,4) NOT NULL, status VARCHAR(20) NOT NULL, modifieddate TIMESTAMP NOT NULL);

-- DB Statement 18: TABLE OrderItem (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.orderitem(orderitemid SERIAL PRIMARY KEY, orderid INTEGER NOT NULL, bookid INTEGER NOT NULL, quantity INTEGER NOT NULL, price NUMERIC(19,4) NOT NULL, modifieddate TIMESTAMP NOT NULL);

-- DB Statement 19: TABLE Person (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.person(personid SERIAL PRIMARY KEY, persontype CHAR(2) NOT NULL, namestyle BOOLEAN NOT NULL, title VARCHAR(8), firstname VARCHAR(100) NOT NULL, middlename VARCHAR(100), lastname VARCHAR(100) NOT NULL, suffix VARCHAR(10), emailpromotion INTEGER NOT NULL, modifieddate TIMESTAMP NOT NULL);

-- DB Statement 20: TABLE Shopping (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.shopping(shoppingid SERIAL PRIMARY KEY, customerid INTEGER NOT NULL, orderdate DATE NOT NULL, totalamount DECIMAL(10, 2) NOT NULL, status VARCHAR(50) NOT NULL, shippingaddress VARCHAR(200) NOT NULL, paymentmethod VARCHAR(50) NOT NULL, createdat TIMESTAMP NOT NULL, updatedat TIMESTAMP NOT NULL);

-- DB Statement 21: TABLE Coupons (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.coupons(couponid SERIAL PRIMARY KEY, couponcode VARCHAR(20) NOT NULL, discountpercent DECIMAL(5, 2) NOT NULL, expirationdate DATE NOT NULL, isactive BOOLEAN NOT NULL, createddate TIMESTAMP NOT NULL, maxuses INTEGER NOT NULL, currentuses INTEGER NOT NULL);

-- DB Statement 22: TABLE ProductSaleRegions (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.productsaleregions(regionid SERIAL PRIMARY KEY, regionname VARCHAR(50) NOT NULL);

-- DB Statement 23: TABLE ProductSales (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.productsales(saleid SERIAL PRIMARY KEY, productid INTEGER NOT NULL, regionid INTEGER NOT NULL, saledate DATE NOT NULL, quantity INTEGER NOT NULL, unitprice DECIMAL(10, 2) NOT NULL, totalamount DECIMAL(10, 2) NOT NULL, salespersonid INTEGER, discount DECIMAL(5, 2));

-- DB Statement 24: TABLE ReferenceData (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.referencedata(referencedataid SERIAL PRIMARY KEY, type VARCHAR(50) NOT NULL, text VARCHAR(200) NOT NULL, orderindex INTEGER NOT NULL, active BOOLEAN NOT NULL, modifieddate TIMESTAMP NOT NULL);

-- DB Statement 25: TABLE ShoppingCart (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.shoppingcart(shoppingcartid SERIAL PRIMARY KEY, customerid INTEGER NOT NULL, datecreated TIMESTAMP NOT NULL, modifieddate TIMESTAMP NOT NULL);

-- DB Statement 26: TABLE ShoppingCartItem (db/bobsusedbooks.sql)
CREATE TABLE bobsbookstore_dbo.shoppingcartitem(shoppingcartitemid SERIAL PRIMARY KEY, shoppingcartid INTEGER NOT NULL, bookid INTEGER NOT NULL, quantity INTEGER NOT NULL, datecreated TIMESTAMP NOT NULL, modifieddate TIMESTAMP NOT NULL);

-- DB Statement 27: FUNCTION ufnCalculateCustomerLifetimeValue (db/bobsusedbooks.sql)
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.ufncalculatecustomerlifetimevalue(p_customerid INTEGER) RETURNS DECIMAL(10, 2) AS $$ DECLARE v_totalspent DECIMAL(10, 2); v_firstorderdate DATE; v_dayssincefirstorder INTEGER; v_lifetimevalue DECIMAL(10, 2); BEGIN SELECT SUM(totalamount), MIN(orderdate) INTO v_totalspent, v_firstorderdate FROM bobsbookstore_dbo.shopping WHERE customerid = p_customerid AND TRIM(status) != 'Refund Requested'; v_dayssincefirstorder := (CURRENT_DATE - v_firstorderdate); IF v_dayssincefirstorder = 0 THEN v_lifetimevalue := v_totalspent; ELSE v_lifetimevalue := (v_totalspent / v_dayssincefirstorder) * 365.25; END IF; RETURN v_lifetimevalue; END; $$ LANGUAGE plpgsql;;

-- DB Statement 28: FUNCTION ufnGetAccountingEndDate (db/bobsusedbooks.sql)
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.ufngetaccountingenddate() RETURNS TIMESTAMP AS $$ BEGIN RETURN CURRENT_TIMESTAMP + INTERVAL '1 month'; END; $$ LANGUAGE plpgsql;;

-- DB Statement 29: FUNCTION ufnGetAccountingStartDate (db/bobsusedbooks.sql)
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.ufngetaccountingstartdate() RETURNS TIMESTAMP AS $$ BEGIN RETURN '2003-07-01'::TIMESTAMP; END; $$ LANGUAGE plpgsql;;

-- DB Statement 30: FUNCTION ufnGetDocumentStatusText (db/bobsusedbooks.sql)
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.ufngetdocumentstatustext(p_status SMALLINT) RETURNS VARCHAR(16) AS $$ DECLARE v_ret VARCHAR(16); BEGIN v_ret := CASE p_status WHEN 1 THEN 'Pending approval' WHEN 2 THEN 'Approved' WHEN 3 THEN 'Obsolete' ELSE '** Invalid **' END; RETURN v_ret; END; $$ LANGUAGE plpgsql;;

-- DB Statement 31: FUNCTION ufnGetPurchaseOrderStatusText (db/bobsusedbooks.sql)
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.ufngetpurchaseorderstatustext(p_status SMALLINT) RETURNS VARCHAR(15) AS $$ DECLARE v_ret VARCHAR(15); BEGIN v_ret := CASE p_status WHEN 1 THEN 'Pending' WHEN 2 THEN 'Approved' WHEN 3 THEN 'Rejected' WHEN 4 THEN 'Complete' ELSE '** Invalid **' END; RETURN v_ret; END; $$ LANGUAGE plpgsql;;

-- DB Statement 32: FUNCTION ufnGetSalesOrderStatusText (db/bobsusedbooks.sql)
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.ufngetsalesorderstatustext(p_status SMALLINT) RETURNS VARCHAR(15) AS $$ DECLARE v_ret VARCHAR(15); BEGIN v_ret := CASE p_status WHEN 1 THEN 'In process' WHEN 2 THEN 'Approved' WHEN 3 THEN 'Backordered' WHEN 4 THEN 'Rejected' WHEN 5 THEN 'Shipped' WHEN 6 THEN 'Cancelled' ELSE '** Invalid **' END; RETURN v_ret; END; $$ LANGUAGE plpgsql;;

-- DB Statement 33: FUNCTION ufnLeadingZeros (db/bobsusedbooks.sql)
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.ufnleadingzeros(p_value INTEGER) RETURNS VARCHAR(8) AS $$ BEGIN RETURN LPAD(p_value::TEXT, 8, '0'); END; $$ LANGUAGE plpgsql;;

-- DB Statement 34: VIEW VwTopMembers (db/bobsusedbooks.sql)
CREATE OR REPLACE VIEW bobsbookstore_dbo.vwtopmembers AS SELECT memberid, firstname, lastname, email, membershiplevel, joindate, totalspent FROM bobsbookstore_dbo.members WHERE totalspent > 1000 AND membershiplevel IN ('Gold', 'Platinum');;

-- DB Statement 35: VIEW VwOpenCoupons (db/bobsusedbooks.sql)
CREATE OR REPLACE VIEW bobsbookstore_dbo.vwopencoupons AS SELECT couponid, couponcode, discountpercent, expirationdate, maxuses, currentuses, (maxuses - currentuses) AS remaininguses FROM bobsbookstore_dbo.coupons WHERE isactive = TRUE AND expirationdate >= CURRENT_DATE;;

-- DB Statement 36: VIEW VwCustomerShopping (db/bobsusedbooks.sql)
CREATE OR REPLACE VIEW bobsbookstore_dbo.vwcustomershopping AS SELECT s.shoppingid, s.customerid, s.orderdate, s.totalamount, s.status, s.shippingaddress, s.paymentmethod, m.firstname, m.lastname, m.membershiplevel FROM bobsbookstore_dbo.shopping s INNER JOIN bobsbookstore_dbo.members m ON s.customerid = m.memberid;;

-- DB Statement 37: VIEW VwRegionalSales (db/bobsusedbooks.sql)
CREATE OR REPLACE VIEW bobsbookstore_dbo.vwregionalsales (regionname, regionalessum) AS SELECT r.regionname, SUM(ps.totalamount) AS regionalessum FROM bobsbookstore_dbo.productsales ps INNER JOIN bobsbookstore_dbo.productsaleregions r ON ps.regionid = r.regionid GROUP BY r.regionname;;

-- DB Statement 38: STORED_PROCEDURE uspDeleteAuthor (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspdeleteauthor(p_businessentityid INTEGER) LANGUAGE plpgsql AS $$ BEGIN DELETE FROM bobsbookstore_dbo.author WHERE businessentityid = p_businessentityid; IF NOT FOUND THEN RAISE EXCEPTION 'No author found with the provided BusinessEntityID.'; END IF; EXCEPTION WHEN OTHERS THEN CALL bobsbookstore_dbo.usplogerror(); RAISE; END; $$;;

-- DB Statement 39: STORED_PROCEDURE uspGetAuthorManagers (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspgetauthormanagers(p_businessentityid INTEGER) LANGUAGE plpgsql AS $$ BEGIN PERFORM businessentityid, loginid, jobtitle FROM bobsbookstore_dbo.author WHERE businessentityid = p_businessentityid; END; $$;;

-- DB Statement 40: STORED_PROCEDURE uspGetBillOfMaterials (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspgetbillofmaterials(p_startproductid INTEGER, p_checkdate TIMESTAMP) LANGUAGE plpgsql AS $$ BEGIN PERFORM billofmaterialsid, productassemblyid, componentid, startdate, enddate, unitmeasurecode, bomlevel, perassemblyqty FROM bobsbookstore_dbo.billofmaterials WHERE productassemblyid = p_startproductid AND p_checkdate >= startdate AND p_checkdate <= COALESCE(enddate, p_checkdate); END; $$;;

-- DB Statement 41: STORED_PROCEDURE uspGetManagerAuthors (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspgetmanagerauthors(p_managerid INTEGER) LANGUAGE plpgsql AS $$ BEGIN PERFORM businessentityid, loginid, jobtitle FROM bobsbookstore_dbo.author; END; $$;;

-- DB Statement 42: STORED_PROCEDURE uspGetWhereUsedProductID (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspgetwhereusedproductid(p_startproductid INTEGER, p_checkdate TIMESTAMP) LANGUAGE plpgsql AS $$ BEGIN PERFORM billofmaterialsid, productassemblyid, componentid, startdate, enddate, unitmeasurecode, bomlevel, perassemblyqty FROM bobsbookstore_dbo.billofmaterials WHERE componentid = p_startproductid AND p_checkdate >= startdate AND p_checkdate <= COALESCE(enddate, p_checkdate); END; $$;;

-- DB Statement 43: STORED_PROCEDURE uspPrintError (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspprinterror() LANGUAGE plpgsql AS $$ BEGIN RAISE NOTICE 'Error information logged'; END; $$;;

-- DB Statement 44: STORED_PROCEDURE uspLogError (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.usplogerror(INOUT p_errorlogid INTEGER DEFAULT 0) LANGUAGE plpgsql AS $$ BEGIN INSERT INTO bobsbookstore_dbo.errorlog (errortime, username, errornumber, errorseverity, errorstate, errorprocedure, errorline, errormessage) VALUES (CURRENT_TIMESTAMP, CURRENT_USER, 0, 0, 0, '', 0, 'Error logged'); p_errorlogid := lastval(); EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'An error occurred in stored procedure uspLogError'; p_errorlogid := -1; END; $$;;

-- DB Statement 45: STORED_PROCEDURE uspUpdateAuthorLogin (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspupdateauthorlogin(p_businessentityid INTEGER, p_organizationnode VARCHAR(50) DEFAULT NULL, p_loginid VARCHAR(256), p_jobtitle VARCHAR(50), p_hiredate TIMESTAMP, p_currentflag BOOLEAN) LANGUAGE plpgsql AS $$ BEGIN UPDATE bobsbookstore_dbo.author SET organizationnode = p_organizationnode, loginid = p_loginid, jobtitle = p_jobtitle, hiredate = p_hiredate, currentflag = p_currentflag WHERE businessentityid = p_businessentityid; EXCEPTION WHEN OTHERS THEN CALL bobsbookstore_dbo.usplogerror(); END; $$;;

-- DB Statement 46: STORED_PROCEDURE uspUpdateAuthorPersonalInfo (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspupdateauthorpersonalinfo(p_businessentityid INTEGER, p_nationalidnumber VARCHAR(15), p_birthdate TIMESTAMP, p_maritalstatus CHAR(1), p_gender CHAR(1)) LANGUAGE plpgsql AS $$ BEGIN UPDATE bobsbookstore_dbo.author SET nationalidnumber = p_nationalidnumber, birthdate = p_birthdate, maritalstatus = p_maritalstatus, gender = p_gender WHERE businessentityid = p_businessentityid; EXCEPTION WHEN OTHERS THEN CALL bobsbookstore_dbo.usplogerror(); END; $$;;

-- DB Statement 47: STORED_PROCEDURE uspGetProductData (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspgetproductdata(p_productid INTEGER) LANGUAGE plpgsql AS $$ BEGIN PERFORM productid, name, productnumber, listprice, standardcost FROM bobsbookstore_dbo.product WHERE productid = p_productid; END; $$;;

-- DB Statement 48: STORED_PROCEDURE uspGetTopRegion (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspgettopregion() LANGUAGE plpgsql AS $$ BEGIN PERFORM r.regionname, SUM(ps.totalamount) AS totalsales FROM bobsbookstore_dbo.productsales ps INNER JOIN bobsbookstore_dbo.productsaleregions r ON ps.regionid = r.regionid GROUP BY r.regionname ORDER BY totalsales DESC LIMIT 1; END; $$;;

-- DB Statement 49: STORED_PROCEDURE uspDeleteOldCoupons (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspdeleteoldcoupons() LANGUAGE plpgsql AS $$ BEGIN DELETE FROM bobsbookstore_dbo.coupons WHERE expirationdate < CURRENT_DATE AND isactive = FALSE; EXCEPTION WHEN OTHERS THEN CALL bobsbookstore_dbo.usplogerror(); RAISE; END; $$;;

-- DB Statement 50: STORED_PROCEDURE uspProcessRefunds (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspprocessrefunds() LANGUAGE plpgsql AS $$ BEGIN UPDATE bobsbookstore_dbo.shopping SET status = 'Refunded', updatedat = CURRENT_TIMESTAMP WHERE TRIM(status) = 'Refund Requested'; EXCEPTION WHEN OTHERS THEN CALL bobsbookstore_dbo.usplogerror(); RAISE; END; $$;;

-- DB Statement 51: STORED_PROCEDURE uspShoppingLevelAmount (db/bobsusedbooks.sql)
CREATE OR REPLACE PROCEDURE bobsbookstore_dbo.uspshoppinglevelamount(p_level VARCHAR(20)) LANGUAGE plpgsql AS $$ BEGIN PERFORM m.memberid, m.firstname, m.lastname, SUM(s.totalamount) AS totalspent FROM bobsbookstore_dbo.members m INNER JOIN bobsbookstore_dbo.shopping s ON m.memberid = s.customerid WHERE m.membershiplevel = p_level GROUP BY m.memberid, m.firstname, m.lastname ORDER BY totalspent DESC; END; $$;;

-- DB Statement 52: TRIGGER ddlDatabaseTriggerLog (db/bobsusedbooks.sql)
-- PostgreSQL does not have DDL triggers equivalent to SQL Server DDL_DATABASE_LEVEL_EVENTS. Use event triggers instead.
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.ddldatabasetriggerlog_func() RETURNS event_trigger LANGUAGE plpgsql AS $$ BEGIN INSERT INTO bobsbookstore_dbo.databaselog (posttime, databaseuser, event, schema_name, object, tsql, xmlevent) VALUES (CURRENT_TIMESTAMP, CURRENT_USER, TG_EVENT, TG_TAG, '', '', ''); END; $$;
CREATE EVENT TRIGGER ddldatabasetriggerlog ON ddl_command_end EXECUTE FUNCTION bobsbookstore_dbo.ddldatabasetriggerlog_func();;

-- DB Statement 53: INSERT INSERT_Author (db/adven-data.sql)
INSERT INTO bobsbookstore_dbo.author (businessentityid, nationalidnumber, loginid, organizationnode, jobtitle, birthdate, maritalstatus, gender, hiredate, vacationhours, currentflag, modifieddate) VALUES (1, '295847284', 'adventure-works\ken0', '/', 'Chief Executive Officer', '1969-01-29'::DATE, 'S', 'M', '2009-01-14'::DATE, 99, TRUE, '2025-08-25T02:04:09.597'::TIMESTAMP);

-- DB Statement 54: INSERT INSERT_Person (db/adven-data.sql)
INSERT INTO bobsbookstore_dbo.person (personid, persontype, namestyle, title, firstname, middlename, lastname, suffix, emailpromotion, modifieddate) VALUES (1, 'EM', FALSE, NULL, 'Ken', 'J', 'Sanchez', NULL, 0, '2025-08-25T02:04:09.597'::TIMESTAMP);

-- DB Statement 55: INSERT INSERT_Customer (db/adven-data.sql)
INSERT INTO bobsbookstore_dbo.customer (customerid, personid, accountnumber, modifieddate) VALUES (1, 1, 'AW00000001', '2025-08-25T02:04:09.597'::TIMESTAMP);

-- DB Statement 56: INSERT INSERT_Product (db/adven-data.sql)
INSERT INTO bobsbookstore_dbo.product (productid, name, productnumber, makeflag, finishedgoodsflag, color, safetystocklevel, reorderpoint, standardcost, listprice, size, sizeunitmeasurecode, weightunitmeasurecode, weight, daystomanufacture, productline, class, style, sellstartdate, sellenddate, discontinueddate, modifieddate) VALUES (1, 'Adjustable Race', 'AR-5381', FALSE, FALSE, NULL, 1000, 750, 0.0000, 0.0000, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, '2008-04-30T00:00:00.000'::TIMESTAMP, NULL, NULL, '2014-02-08T10:01:36.827'::TIMESTAMP);

-- DB Statement 57: INSERT INSERT_BillOfMaterials (db/adven-data.sql)
INSERT INTO bobsbookstore_dbo.billofmaterials (billofmaterialsid, productassemblyid, componentid, startdate, enddate, unitmeasurecode, bomlevel, perassemblyqty, modifieddate) VALUES (893, 749, 3, '2008-04-30T00:00:00.000'::TIMESTAMP, NULL, 'EA ', 1, 1.00, '2014-02-08T10:01:36.827'::TIMESTAMP);

-- DB Statement 58: INSERT INSERT_Members (db/adven-data.sql)
INSERT INTO bobsbookstore_dbo.members (memberid, firstname, lastname, email, membershiplevel, joindate, totalspent) VALUES (1, 'John', 'Smith', 'john.smith@example.com', 'Gold', '2023-01-15'::DATE, 2500.00);

-- DB Statement 59: INSERT INSERT_Shopping (db/adven-data.sql)
INSERT INTO bobsbookstore_dbo.shopping (shoppingid, customerid, orderdate, totalamount, status, shippingaddress, paymentmethod, createdat, updatedat) VALUES (1, 1, '2024-01-15'::DATE, 150.00, 'Completed', '123 Main St, City, ST 12345', 'Credit Card', '2024-01-15T10:30:00'::TIMESTAMP, '2024-01-15T10:30:00'::TIMESTAMP);

-- DB Statement 60: INSERT INSERT_ProductSaleRegions (db/adven-data.sql)
INSERT INTO bobsbookstore_dbo.productsaleregions (regionid, regionname) VALUES (1, 'Northeast');

-- DB Statement 61: INSERT INSERT_ProductSales (db/adven-data.sql)
INSERT INTO bobsbookstore_dbo.productsales (saleid, productid, regionid, saledate, quantity, unitprice, totalamount, salespersonid, discount) VALUES (1, 1, 1, '2024-01-15'::DATE, 10, 29.99, 299.90, 1, 0.00);


-- Statement 5: ProductsController.cs FindAllProducts (line ~36)
-- Converted from MS SQL EXEC to PostgreSQL CALL syntax with lowercase schema
CALL bobsbookstore_dbo.uspgetproductdata();
