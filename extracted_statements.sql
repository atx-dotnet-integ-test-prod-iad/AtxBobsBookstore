===============================================================================
EXTRACTED SQL STATEMENTS - SQL Server to PostgreSQL Migration
===============================================================================
Project: Bob's Bookstore ADO.NET Application
Extraction Date: 2026-02-10
Total Statements Extracted: 5
===============================================================================

===============================================================================
SOURCE: app/Bookstore.Web/Controllers/AuthorsController.cs
METHOD: EditUsingStoredProcedure
LINE: ~163
DESCRIPTION: Stored procedure call to update author personal information
PARAMETERS: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
===============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
===============================================================================


===============================================================================
SOURCE: app/Bookstore.Web/Controllers/AuthorsController.cs
METHOD: FindAllAuthorsEmbeddedSql
LINE: ~189
DESCRIPTION: Select all authors from the author table
PARAMETERS: None
===============================================================================
SELECT * FROM bobsbookstore_dbo.author
===============================================================================


===============================================================================
SOURCE: app/Bookstore.Web/Controllers/AuthorsController.cs
METHOD: DeleteAuthorEmbeddedSql
LINE: ~208
DESCRIPTION: Stored procedure call to delete an author
PARAMETERS: @BusinessEntityID (int)
===============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
===============================================================================


===============================================================================
SOURCE: app/Bookstore.Web/Controllers/AuthorsController.cs
METHOD: SelectAuthorsByHireYear
LINE: ~228
DESCRIPTION: Select authors by hire year with formatted date and age calculation
PARAMETERS: @HireDate (int - hire year)
===============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
===============================================================================


===============================================================================
SOURCE: app/Bookstore.Web/Controllers/ProductsController.cs
METHOD: FindAllProducts
LINE: ~32
DESCRIPTION: Stored procedure call to get all product data
PARAMETERS: None
===============================================================================
EXEC [dbo].[uspGetProductData];
===============================================================================


===============================================================================
SUMMARY OF SQL STATEMENTS
===============================================================================
Total SQL Statements: 5
- Stored Procedure Calls: 3 (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
- Direct SELECT Queries: 2 (FindAllAuthorsEmbeddedSql, SelectAuthorsByHireYear)

SQL Server Specific Features Identified:
1. DECLARE statements for variables
2. EXEC for stored procedure execution
3. FORMAT() function for date formatting
4. DATEDIFF() function for date calculations
5. GETDATE() function for current date
6. DATEPART() function for extracting date parts
7. Schema qualified object names ([dbo].[procedureName])

All statements will need conversion to PostgreSQL syntax using DMS MCP tool.
===============================================================================
