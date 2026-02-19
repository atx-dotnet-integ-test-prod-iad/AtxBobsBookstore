-- ================================================================================
-- Converted SQL Statements Catalog
-- Microsoft SQL Server to PostgreSQL Conversion Results
-- ================================================================================
-- This file contains all SQL statements converted from SQL Server to PostgreSQL
-- syntax. Each statement includes the original SQL Server version and the
-- converted PostgreSQL equivalent.
-- ================================================================================

-- ================================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ================================================================================
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
--
-- PostgreSQL Converted Statement:

SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ================================================================================
-- STATEMENT 2: Select All Authors
-- ================================================================================
-- Original SQL Server Statement:
-- SELECT * FROM bobsbookstore_dbo.author
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
--
-- PostgreSQL Converted Statement:

SELECT * FROM bobsbookstore_dbo.author

-- ================================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ================================================================================
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
--
-- PostgreSQL Converted Statement:

SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ================================================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ================================================================================
-- Original SQL Server Statement:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
--
-- PostgreSQL Converted Statement:

SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ================================================================================
-- STATEMENT 5: Get All Products (Stored Procedure Call)
-- ================================================================================
-- Original SQL Server Statement:
-- EXEC [dbo].[uspGetProductData];
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
--
-- PostgreSQL Converted Statement:

SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ================================================================================
-- END OF CONVERTED STATEMENTS
-- ================================================================================
-- Total Original Statements: 5
-- Successfully Converted: 5 (all via manual conversion after DMS failure)
-- DMS Tool Successes: 0
-- Manual Conversions: 5
-- ================================================================================
