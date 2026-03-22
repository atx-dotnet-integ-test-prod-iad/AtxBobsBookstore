-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Date: 2026-03-22
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according
--   to the specified selection rules.
-- Note: All statements were already in PostgreSQL syntax with lowercase schema
--   object names. Manual conversion preserves existing PostgreSQL syntax.
-- ============================================================================

-- Statement 1: ProductsController.cs (FindAllProducts method, line 34)
-- Original: SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
-- Converted: (already PostgreSQL compatible with lowercase naming)
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- Statement 2: AuthorsController.cs (EditUsingStoredProcedure method, line 163)
-- Original: SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
-- Converted: (already PostgreSQL compatible with lowercase naming)
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 3: AuthorsController.cs (FindAllAuthorsEmbeddedSql method, line 187)
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- Converted: (already PostgreSQL compatible with lowercase naming)
SELECT * FROM bobsbookstore_dbo.author

-- Statement 4: AuthorsController.cs (DeleteAuthorEmbeddedSql method, line 208)
-- Original: SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
-- Converted: (already PostgreSQL compatible with lowercase naming)
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 5: AuthorsController.cs (SelectAuthorsByHireYear method, line 228)
-- Original: SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
-- Converted: (already PostgreSQL compatible with lowercase naming and PostgreSQL functions)
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
