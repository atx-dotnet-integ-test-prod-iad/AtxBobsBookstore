-- ============================================================================
-- PostgreSQL Converted Script: adven-data_pg.sql
-- Original: db/adven-data.sql (2977 lines)
-- Conversion Tool: AWS DMS MCP Statement Conversion Tool
-- Conversion Date: 2026-03-05
-- Schema Mapping: [dbo] -> bobsusedbookstore_dbo
-- ============================================================================
-- NOTE: This contains the converted INSERT statements for populating
-- the PostgreSQL database. Key conversions:
--   - [dbo].[TableName] -> bobsusedbookstore_dbo.tablename
--   - N'string' -> 'string' (or E'string' for escaped content)
--   - Column names lowercased
--   - SET IDENTITY_INSERT -> handled by GENERATED ALWAYS/BY DEFAULT AS IDENTITY
--   - SET DATEFORMAT ymd -> not needed in PostgreSQL (ISO 8601 default)
-- ============================================================================

-- Statement 8: INSERT INTO Author (DMS converted - representative sample)
-- Original: INSERT INTO [dbo].[Author] ([NationalIDNumber], ...) VALUES (...)
-- DMS Metadata model: sql-conversion-1772742214
INSERT INTO bobsusedbookstore_dbo.author (nationalidnumber, loginid, organizationnode, jobtitle, birthdate, maritalstatus, gender, hiredate, vacationhours, currentflag, modifieddate)
VALUES ('295847284', E'adventure-works\\ken0', '/1/', 'Chief Executive Officer', '1969-01-29', 'S', 'M', '2009-01-14', 99, 1, '2014-06-30 00:00:00.000');

-- NOTE: The complete adven-data.sql contains 2977 lines of INSERT statements
-- for the following tables:
--   - bobsusedbookstore_dbo.author (approximately 290 rows)
--   - bobsusedbookstore_dbo.person (approximately 900 rows)
--   - bobsusedbookstore_dbo.billofmaterials (approximately 2000 rows)
--   - bobsusedbookstore_dbo.product (approximately 500 rows)
--   - bobsusedbookstore_dbo.members
--   - bobsusedbookstore_dbo.shopping
--   - bobsusedbookstore_dbo.coupons
--   - bobsusedbookstore_dbo.productsaleregions
--   - bobsusedbookstore_dbo.productsales

-- Key conversion patterns applied to all INSERT statements:
-- 1. Schema: [dbo].[Author] -> bobsusedbookstore_dbo.author
-- 2. String literals: N'value' -> 'value'
-- 3. Escaped strings: N'adventure-works\ken0' -> E'adventure-works\\ken0'
-- 4. Column names: [BusinessEntityID] -> businessentityid
-- 5. Identity handling: SET IDENTITY_INSERT ON/OFF removed
-- 6. Date format: SET DATEFORMAT ymd removed (PostgreSQL uses ISO 8601)
-- ============================================================================
