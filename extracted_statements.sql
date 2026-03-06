-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET ADO Application
-- Date: 2026-03-06 (Re-processed and verified - DMS MCP Tool Run)
-- Total Statements: 5
-- Files Scanned: All .cs files in app/ directory
-- Files with SQL: AuthorsController.cs, ProductsController.cs
-- Verification: Searched for ExecuteSqlRaw, SqlQueryRaw, FromSqlRaw, SqlQuery, ExecuteSql,
--               FromSql, SELECT, INSERT, UPDATE, DELETE, EXEC, DECLARE, CALL, SqlConnection,
--               SqlCommand, SqlDataReader, StringBuilder patterns across all .cs files.
-- Result: 5 SQL statements confirmed. No additional SQL statements found in repository files
--         (BookRepository.cs, OfferRepository.cs, OrderRepository.cs, ReferenceDataRepository.cs
--          all use EF LINQ queries only, no raw SQL).

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: ~163 (sql string assignment)
-- Type: Stored procedure call with parameters
-- Original MS SQL Server:
EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: ~187 (sql string assignment)
-- Type: Simple SELECT query
-- Original MS SQL Server:
SELECT * FROM Author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: ~208 (sql string assignment)
-- Type: Stored procedure call with parameter
-- Original MS SQL Server:
EXEC dbo.uspDeleteAuthor @BusinessEntityID

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: ~228 (sql string assignment)
-- Type: SELECT with FORMAT, DATEDIFF, DATEPART functions and parameterized WHERE clause
-- Original MS SQL Server:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate

-- Statement 5: ProductsController.cs - FindAllProducts method
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line: ~34 (sql string assignment)
-- Type: Stored procedure execution
-- Original MS SQL Server:
EXEC [dbo].[uspGetProductData]
