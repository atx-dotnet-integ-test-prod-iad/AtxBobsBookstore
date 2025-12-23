-- SQL STATEMENTS EXTRACTED FROM BOBSBOOKSTORE APPLICATION
-- Extraction Date: 2024-12-23
-- Source: AuthorsController.cs

-- ============================================================================
-- STATEMENT 1: FindAllAuthorsEmbeddedSql
-- Location: AuthorsController.cs, Line ~167
-- Method: FindAllAuthorsEmbeddedSql()
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 2: EditUsingStoredProcedure
-- Location: AuthorsController.cs, Line ~143
-- Method: EditUsingStoredProcedure()
-- Contains SQL Server specific syntax: DECLARE, EXEC, [dbo].[uspUpdateAuthorPersonalInfo]
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql
-- Location: AuthorsController.cs, Line ~192
-- Method: DeleteAuthorEmbeddedSql()
-- Contains SQL Server specific syntax: DECLARE, EXEC, [dbo].[uspDeleteAuthor]
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear
-- Location: AuthorsController.cs, Line ~211
-- Method: SelectAuthorsByHireYear()
-- Contains SQL Server specific syntax: FORMAT, DATEDIFF, GETDATE, DATEPART
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
