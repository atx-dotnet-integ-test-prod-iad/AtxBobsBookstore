-- ============================================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: MS SQL Server to PostgreSQL Migration
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Date: 2026-03-24
-- Note: All 8 DMS tool calls failed with metadata model creation error.
--       Error: "No objects were found according to the specified selection rules."
--       Manual conversion applied with lowercase schema object names per
--       fallback procedure (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA).
-- DMS Parameters Used:
--   migration_project_identifier: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
--   database_name: BobsBookstore
--   schema_name: dbo
--   region: us-east-1
--   server_name: 172.31.82.226
-- DMS Retry Attempt: 2 (second run, first run also failed)
-- ============================================================================

-- ============================================================================
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure method
-- Original: EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- Conversion: EXEC stored procedure call -> PostgreSQL SELECT function call with lowercase schema
-- DMS Status: FAILED | Fallback: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp (Run 2): 2026-03-24T17:44:51.458743
-- DMS Timestamp (Run 1): 2026-03-24T17:11:55.765343
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql method
-- Original: SELECT * FROM [dbo].[Author];
-- Conversion: [dbo].[Author] -> bobsbookstore_dbo.author (lowercase)
-- DMS Status: FAILED | Fallback: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp (Run 2): 2026-03-24T17:45:18.093358
-- DMS Timestamp (Run 1): 2026-03-24T17:12:18.811977
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 3: DeleteAuthorEmbeddedSql method
-- Original: EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- Conversion: EXEC stored procedure call -> PostgreSQL SELECT function call with lowercase schema
-- DMS Status: FAILED | Fallback: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp (Run 2): 2026-03-24T17:45:40.375330
-- DMS Timestamp (Run 1): 2026-03-24T17:12:42.044272
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear method
-- Original: SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;
-- Conversion: CONVERT -> TO_CHAR, DATEDIFF/GETDATE -> EXTRACT/AGE/CURRENT_DATE, YEAR() -> EXTRACT(YEAR FROM), column names -> lowercase
-- DMS Status: FAILED | Fallback: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp (Run 2): 2026-03-24T17:46:02.836282
-- DMS Timestamp (Run 1): 2026-03-24T17:13:06.441657
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================================
-- Source: app/Bookstore.Web/Controllers/ProductsController.cs
-- ============================================================================

-- Statement 5: FindAllProducts method
-- Original: EXEC [dbo].[uspGetProductData];
-- Conversion: EXEC stored procedure -> SELECT * FROM function call with lowercase schema
-- DMS Status: FAILED | Fallback: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp (Run 2): 2026-03-24T17:46:25.955663
-- DMS Timestamp (Run 1): 2026-03-24T17:13:29.503498
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================================
-- Source: db/adven.sql (Representative CREATE TABLE)
-- ============================================================================

-- Statement 6: Representative CREATE TABLE from db scripts
-- Original: CREATE TABLE [dbo].[Author](...) with IDENTITY, NVARCHAR, BIT, DATETIME, ON [PRIMARY]
-- Conversion: [dbo].[Author] -> bobsbookstore_dbo.author, IDENTITY -> GENERATED ALWAYS AS IDENTITY, NVARCHAR -> VARCHAR, NCHAR -> CHAR, BIT -> BOOLEAN, DATETIME -> TIMESTAMP, ON [PRIMARY] -> removed
-- DMS Status: FAILED | Fallback: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp (Run 2): 2026-03-24T17:46:54.855571
-- DMS Timestamp (Run 1): 2026-03-24T17:13:57.661816
CREATE TABLE bobsbookstore_dbo.author(businessentityid INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, nationalidnumber VARCHAR(15) NOT NULL, loginid VARCHAR(256) NOT NULL, jobtitle VARCHAR(50) NOT NULL, birthdate DATE NOT NULL, maritalstatus CHAR(1) NOT NULL, gender CHAR(1) NOT NULL, hiredate DATE NOT NULL, vacationhours SMALLINT NOT NULL, currentflag BOOLEAN NOT NULL, modifieddate TIMESTAMP NOT NULL, PRIMARY KEY (businessentityid));

-- ============================================================================
-- Source: db/adven-data.sql (Representative INSERT)
-- ============================================================================

-- Statement 7: Representative INSERT from db scripts
-- Original: INSERT INTO [dbo].[Author] ([col],...) VALUES (N'val',...)
-- Conversion: [dbo].[Author] -> bobsbookstore_dbo.author, [col] -> col (lowercase), N'val' -> 'val', 1 -> true for BIT/BOOLEAN
-- DMS Status: FAILED | Fallback: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp (Run 2): 2026-03-24T17:47:18.413318
-- DMS Timestamp (Run 1): 2026-03-24T17:14:23.651036
INSERT INTO bobsbookstore_dbo.author (nationalidnumber, loginid, jobtitle, birthdate, maritalstatus, gender, hiredate, vacationhours, currentflag, modifieddate) VALUES ('295847284', 'adventure-works\ken0', 'Chief Executive Officer', '1969-01-29', 'S', 'M', '2009-01-14', 99, true, '2014-06-30');

-- ============================================================================
-- Source: db/bobsusedbooks.sql (Representative CREATE VIEW)
-- ============================================================================

-- Statement 8: Representative CREATE VIEW from db scripts
-- Original: CREATE VIEW [dbo].[VwTopMembers] AS SELECT ... FROM [dbo].[Members] ...
-- Conversion: [dbo].[Name] -> bobsbookstore_dbo.name (lowercase), column names -> lowercase
-- DMS Status: FAILED | Fallback: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp (Run 2): 2026-03-24T17:47:41.560918
-- DMS Timestamp (Run 1): 2026-03-24T17:14:56.085279
CREATE VIEW bobsbookstore_dbo.vwtopmembers AS SELECT * FROM (SELECT customerid, firstname, lastname, email, totalordersum, ROW_NUMBER() OVER (ORDER BY totalordersum DESC) AS rownum FROM bobsbookstore_dbo.members) AS rankedmembers WHERE rownum <= 10;
