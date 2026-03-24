-- ============================================================================
-- Converted SQL Statements for PostgreSQL
-- Source: Microsoft SQL Server → Target: PostgreSQL
-- Conversion Date: 2026-03-24
-- Total Statements: 5
-- DMS Tool Status: All 5 statements failed DMS conversion
-- DMS Failure Reason: Metadata model creation failed - No objects were found
--                     according to the specified selection rules
-- Fallback Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method
-- Original MSSQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- DMS Timestamp: 2026-03-24T04:52:56.418315
-- Manual Conversion Notes: DECLARE/EXEC/SELECT pattern converted to SELECT function_call(); stored proc name lowercased
SELECT uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method
-- Original MSSQL: SELECT * FROM Author
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- DMS Timestamp: 2026-03-24T04:53:17.629188
-- Manual Conversion Notes: Table name 'Author' converted to lowercase 'author'
SELECT * FROM author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method
-- Original MSSQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- DMS Timestamp: 2026-03-24T04:53:38.618916
-- Manual Conversion Notes: DECLARE/EXEC/SELECT pattern converted to SELECT function_call(); stored proc name lowercased
SELECT uspdeleteauthor(@BusinessEntityID);

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method
-- Original MSSQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- DMS Timestamp: 2026-03-24T04:54:00.678644
-- Manual Conversion Notes:
--   FORMAT(col, 'yyyy-MM-dd HH:mm:ss') -> TO_CHAR(col, 'YYYY-MM-DD HH24:MI:SS')
--   DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM NOW())::INT - EXTRACT(YEAR FROM birthdate)::INT
--   DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM hiredate)
--   All column/table names lowercased
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM NOW())::INT - EXTRACT(YEAR FROM birthdate)::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts method
-- Original MSSQL: EXEC [dbo].[uspGetProductData];
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- DMS Timestamp: 2026-03-24T04:54:22.135581
-- Manual Conversion Notes: EXEC [schema].[proc] converted to SELECT * FROM proc(); stored proc name lowercased
SELECT * FROM uspgetproductdata();
