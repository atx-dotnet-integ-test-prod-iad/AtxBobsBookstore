-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Date: 2026-03-22
-- Total Statements: 5
-- ============================================================================

-- Statement 1: ProductsController.cs (FindAllProducts method, line 34)
-- Context: Calls a stored procedure to get product data
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- Statement 2: AuthorsController.cs (EditUsingStoredProcedure method, line 163)
-- Context: Calls a stored procedure to update author personal info
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 3: AuthorsController.cs (FindAllAuthorsEmbeddedSql method, line 187)
-- Context: Simple select from the author table
SELECT * FROM bobsbookstore_dbo.author

-- Statement 4: AuthorsController.cs (DeleteAuthorEmbeddedSql method, line 208)
-- Context: Calls a stored procedure to delete an author
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 5: AuthorsController.cs (SelectAuthorsByHireYear method, line 228)
-- Context: Complex query with PostgreSQL functions for author age calculation
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
