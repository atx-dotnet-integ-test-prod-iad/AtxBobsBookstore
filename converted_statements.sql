-- CONVERTED SQL STATEMENTS FOR POSTGRESQL
-- Conversion Date: 2024-12-23
-- Source: BobsBookstore Application - AuthorsController.cs
-- Conversion Method: Manual (after DMS tool failures)

-- ============================================================================
-- STATEMENT 1: FindAllAuthorsEmbeddedSql
-- Location: AuthorsController.cs, Line ~167
-- Method: FindAllAuthorsEmbeddedSql()
-- Conversion Method: Manual (DMS tool failed - metadata model creation error)
-- Changes: None required - already PostgreSQL compatible
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 2: EditUsingStoredProcedure
-- Location: AuthorsController.cs, Line ~143
-- Method: EditUsingStoredProcedure()
-- Conversion Method: Manual (DMS tool not attempted due to known issues)
-- Changes: 
--   - Removed DECLARE statement
--   - Changed EXEC to SELECT function call
--   - Removed [dbo]. brackets
--   - Changed @param to $1, $2, $3, $4, $5
-- ============================================================================
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo($1, $2, $3, $4, $5);

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql
-- Location: AuthorsController.cs, Line ~192
-- Method: DeleteAuthorEmbeddedSql()
-- Conversion Method: Manual (DMS tool not attempted due to known issues)
-- Changes:
--   - Removed DECLARE statement
--   - Changed EXEC to SELECT function call
--   - Removed [dbo]. brackets
--   - Changed @param to $1
-- ============================================================================
SELECT bobsbookstore_dbo.uspDeleteAuthor($1);

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear
-- Location: AuthorsController.cs, Line ~211
-- Method: SelectAuthorsByHireYear()
-- Conversion Method: Manual (DMS tool failed - metadata model creation error)
-- Changes:
--   - FORMAT() → TO_CHAR()
--   - Format pattern 'yyyy-MM-dd HH:mm:ss' → 'YYYY-MM-DD HH24:MI:SS'
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) → EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))
--   - DATEPART(YEAR, HireDate) → EXTRACT(YEAR FROM HireDate)
--   - @HireDate → $1
-- ============================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = $1;
