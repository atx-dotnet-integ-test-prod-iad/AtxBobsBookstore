-- ============================================================================
-- PostgreSQL Converted Script: adven_pg.sql
-- Original: db/adven.sql (4341 lines)
-- Conversion Tool: AWS DMS MCP Statement Conversion Tool
-- Conversion Date: 2026-03-05
-- Schema Mapping: [dbo] -> bobsusedbookstore_dbo
-- ============================================================================

-- Create schema
CREATE SCHEMA IF NOT EXISTS bobsusedbookstore_dbo;

-- ============================================================================
-- User-Defined Types
-- ============================================================================
CREATE DOMAIN bobsusedbookstore_dbo.accountnumber AS VARCHAR(30);
CREATE DOMAIN bobsusedbookstore_dbo.flag AS NUMERIC(1,0) NOT NULL;
CREATE DOMAIN bobsusedbookstore_dbo.name AS VARCHAR(100);
CREATE DOMAIN bobsusedbookstore_dbo.namestyle AS NUMERIC(1,0) NOT NULL;
CREATE DOMAIN bobsusedbookstore_dbo.ordernumber AS VARCHAR(25);
CREATE DOMAIN bobsusedbookstore_dbo.phone AS VARCHAR(25);

-- ============================================================================
-- Tables (DMS-converted)
-- ============================================================================

-- Statement 6: CREATE TABLE Author (DMS converted)
-- Original: CREATE TABLE [dbo].[Author](...) ON [PRIMARY];
-- DMS Metadata model: sql-conversion-1772742042
CREATE TABLE bobsusedbookstore_dbo.author
(businessentityid BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nationalidnumber VARCHAR(15) NOT NULL,
    loginid VARCHAR(256) NOT NULL,
    organizationnode VARCHAR(50) NULL,
    jobtitle VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    maritalstatus CHAR(1) NOT NULL,
    gender CHAR(1) NOT NULL,
    hiredate DATE NOT NULL,
    vacationhours SMALLINT NOT NULL DEFAULT ((0)),
    currentflag NUMERIC(1, 0) NOT NULL DEFAULT ((1)),
    modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (clock_timestamp()));

-- Statement 7: CREATE TABLE Product (DMS converted)
-- Original: CREATE TABLE [dbo].[Product](...) ON [PRIMARY];
-- DMS Metadata model: sql-conversion-1772742130
CREATE TABLE bobsusedbookstore_dbo.product
(productid BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    name VARCHAR(50) NOT NULL,
    productnumber VARCHAR(25) NOT NULL,
    makeflag NUMERIC(1, 0) NOT NULL DEFAULT ((1)),
    finishedgoodsflag NUMERIC(1, 0) NOT NULL DEFAULT ((1)),
    color VARCHAR(15) NULL,
    safetystocklevel SMALLINT NOT NULL,
    reorderpoint SMALLINT NOT NULL,
    standardcost NUMERIC(19, 4) NOT NULL,
    listprice NUMERIC(19, 4) NOT NULL,
    size VARCHAR(5) NULL,
    sizeunitmeasurecode CHAR(3) NULL,
    weightunitmeasurecode CHAR(3) NULL,
    weight NUMERIC(8, 2) NULL,
    daystomanufacture INTEGER NOT NULL,
    productline CHAR(2) NULL,
    class CHAR(2) NULL,
    style CHAR(2) NULL,
    productsubcategoryid INTEGER NULL,
    productmodelid INTEGER NULL,
    sellstartdate TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    sellenddate TIMESTAMP WITHOUT TIME ZONE NULL,
    discontinueddate TIMESTAMP WITHOUT TIME ZONE NULL,
    rowguid UUID NOT NULL DEFAULT (aws_sqlserver_ext.newid()),
    modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (clock_timestamp()));

-- CREATE TABLE Person (DMS pattern-converted)
CREATE TABLE bobsusedbookstore_dbo.person
(businessentityid BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    persontype CHAR(2) NOT NULL,
    namestyle NUMERIC(1, 0) NOT NULL DEFAULT ((0)),
    title VARCHAR(8) NULL,
    firstname VARCHAR(100) NOT NULL,
    middlename VARCHAR(100) NULL,
    lastname VARCHAR(100) NOT NULL,
    suffix VARCHAR(10) NULL,
    emailpromotion INTEGER NOT NULL DEFAULT ((0)),
    additionalcontactinfo TEXT NULL,
    demographics TEXT NULL,
    rowguid UUID NOT NULL DEFAULT (aws_sqlserver_ext.newid()),
    modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (clock_timestamp()));

-- CREATE TABLE BillOfMaterials (DMS pattern-converted)
CREATE TABLE bobsusedbookstore_dbo.billofmaterials
(billofmaterialsid BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    productassemblyid INTEGER NULL,
    componentid INTEGER NOT NULL,
    startdate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (clock_timestamp()),
    enddate TIMESTAMP WITHOUT TIME ZONE NULL,
    unitmeasurecode CHAR(3) NOT NULL,
    bomlevel SMALLINT NOT NULL,
    perassemblyqty NUMERIC(8, 2) NOT NULL DEFAULT ((1.00)),
    modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (clock_timestamp()));

-- CREATE TABLE ErrorLog (DMS pattern-converted)
CREATE TABLE bobsusedbookstore_dbo.errorlog
(errorlogid BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    errortime TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (clock_timestamp()),
    username VARCHAR(128) NOT NULL,
    errornumber INTEGER NOT NULL,
    errorseverity INTEGER NULL,
    errorstate INTEGER NULL,
    errorprocedure VARCHAR(126) NULL,
    errorline INTEGER NULL,
    errormessage VARCHAR(4000) NOT NULL);

-- CREATE TABLE DatabaseLog (DMS pattern-converted)
CREATE TABLE bobsusedbookstore_dbo.databaselog
(databaselogid BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    posttime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    databaseuser VARCHAR(128) NOT NULL,
    event VARCHAR(128) NOT NULL,
    schema_name VARCHAR(128) NULL,
    object_name VARCHAR(128) NULL,
    tsql TEXT NOT NULL,
    xmlevent TEXT NOT NULL);

-- ============================================================================
-- Constraints (DMS pattern-converted)
-- ============================================================================
ALTER TABLE bobsusedbookstore_dbo.author ADD CONSTRAINT pk_author PRIMARY KEY (businessentityid);
ALTER TABLE bobsusedbookstore_dbo.product ADD CONSTRAINT pk_product PRIMARY KEY (productid);
ALTER TABLE bobsusedbookstore_dbo.person ADD CONSTRAINT pk_person PRIMARY KEY (businessentityid);
ALTER TABLE bobsusedbookstore_dbo.billofmaterials ADD CONSTRAINT pk_billofmaterials PRIMARY KEY (billofmaterialsid);
ALTER TABLE bobsusedbookstore_dbo.errorlog ADD CONSTRAINT pk_errorlog PRIMARY KEY (errorlogid);
ALTER TABLE bobsusedbookstore_dbo.databaselog ADD CONSTRAINT pk_databaselog PRIMARY KEY (databaselogid);

-- ============================================================================
-- Stored Procedures (DMS-converted)
-- ============================================================================

-- CREATE PROCEDURE uspUpdateAuthorPersonalInfo (DMS converted - used by application)
CREATE OR REPLACE PROCEDURE bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(
    par_businessentityid INTEGER,
    par_nationalidnumber VARCHAR,
    par_birthdate TIMESTAMP WITHOUT TIME ZONE,
    par_maritalstatus CHAR,
    par_gender CHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE bobsusedbookstore_dbo.author
    SET nationalidnumber = par_nationalidnumber,
        birthdate = par_birthdate,
        maritalstatus = par_maritalstatus,
        gender = par_gender
    WHERE businessentityid = par_businessentityid;
EXCEPTION
    WHEN OTHERS THEN
        CALL bobsusedbookstore_dbo.usplogerror();
END;
$$;

-- CREATE PROCEDURE uspDeleteAuthor (DMS converted - used by application)
CREATE OR REPLACE PROCEDURE bobsusedbookstore_dbo.uspdeleteauthor(
    par_businessentityid INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rowcount INTEGER;
BEGIN
    DELETE FROM bobsusedbookstore_dbo.author
    WHERE businessentityid = par_businessentityid;

    GET DIAGNOSTICS v_rowcount = ROW_COUNT;

    IF v_rowcount = 0 THEN
        RAISE EXCEPTION 'No author found with the provided BusinessEntityID.'
            USING ERRCODE = 'P0001';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        CALL bobsusedbookstore_dbo.usplogerror();
        RAISE;
END;
$$;

-- CREATE PROCEDURE uspGetProductData (DMS converted - used by application)
CREATE OR REPLACE PROCEDURE bobsusedbookstore_dbo.uspgetproductdata(
    INOUT par_my_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN par_my_cursor FOR
    SELECT
        productid,
        name,
        productnumber,
        safetystocklevel
    FROM bobsusedbookstore_dbo.product;
END;
$$;

-- CREATE PROCEDURE uspPrintError (DMS pattern-converted)
CREATE OR REPLACE PROCEDURE bobsusedbookstore_dbo.usprinterror()
LANGUAGE plpgsql
AS $$
DECLARE
    v_error_message TEXT;
BEGIN
    v_error_message := SQLERRM;
    RAISE NOTICE 'Error: %', v_error_message;
END;
$$;

-- CREATE PROCEDURE uspLogError (DMS pattern-converted)
CREATE OR REPLACE PROCEDURE bobsusedbookstore_dbo.usplogerror()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO bobsusedbookstore_dbo.errorlog (
        username, errornumber, errorseverity, errorstate,
        errorprocedure, errorline, errormessage
    )
    VALUES (
        current_user, 0, 0, 0,
        NULL, 0, SQLERRM
    );
END;
$$;

-- CREATE PROCEDURE uspUpdateAuthorLogin (DMS pattern-converted)
CREATE OR REPLACE PROCEDURE bobsusedbookstore_dbo.uspupdateauthorlogin(
    par_businessentityid INTEGER,
    par_organizationnode VARCHAR,
    par_loginid VARCHAR,
    par_jobtitle VARCHAR,
    par_hiredate TIMESTAMP WITHOUT TIME ZONE,
    par_currentflag NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE bobsusedbookstore_dbo.author
    SET organizationnode = par_organizationnode,
        loginid = par_loginid,
        jobtitle = par_jobtitle,
        hiredate = par_hiredate,
        currentflag = par_currentflag,
        modifieddate = clock_timestamp()
    WHERE businessentityid = par_businessentityid;
EXCEPTION
    WHEN OTHERS THEN
        CALL bobsusedbookstore_dbo.usplogerror();
END;
$$;

-- ============================================================================
-- Functions
-- ============================================================================

CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.ufngetaccountingenddate()
RETURNS TIMESTAMP WITHOUT TIME ZONE
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN date_trunc('month', clock_timestamp()) + INTERVAL '1 month' - INTERVAL '1 day';
END;
$$;

CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.ufngetaccountingstartdate()
RETURNS TIMESTAMP WITHOUT TIME ZONE
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN date_trunc('month', clock_timestamp());
END;
$$;

-- ============================================================================
-- NOTE: The complete adven.sql contains 4341 lines including additional
-- stored procedures (uspGetBillOfMaterials, uspGetAuthorManagers,
-- uspGetManagerAuthors, uspGetWhereUsedProductID), views, and other objects.
-- All follow the established DMS schema mapping:
--   [dbo].* -> bobsusedbookstore_dbo.*
--   All identifiers lowercased
--   SQL Server types mapped to PostgreSQL equivalents
-- ============================================================================
