================================================================================
EXTRACTED SQL STATEMENTS CATALOG
================================================================================
Project: BobsBookstore - SQL Server to PostgreSQL Migration
Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
Extraction Date: 2026-01-03
Total Statements: 4
================================================================================

================================================================================
Statement ID: 1
================================================================================
Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
Line Number: 187
Method Name: FindAllAuthorsEmbeddedSql()
Statement Type: SELECT
Return Type: List<Author>

SQL Statement:
--------------
SELECT * FROM bobsbookstore_dbo.author

Parameter Definitions:
----------------------
None

SQL Server Specific Functions/Syntax:
--------------------------------------
- Schema notation: bobsbookstore_dbo.author
- Uses SQL Server schema syntax

Context:
--------
This statement retrieves all author records from the author table in the 
bobsbookstore_dbo schema. Used to populate the Authors index page.

================================================================================
Statement ID: 2
================================================================================
Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
Line Number: 163
Method Name: EditUsingStoredProcedure()
Statement Type: EXEC (Stored Procedure Call)
Return Type: bool (based on rows affected)

SQL Statement:
--------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

Parameter Definitions:
----------------------
- @BusinessEntityID (int): The business entity ID of the author to update
- @NationalIDNumber (string): National ID number
- @BirthDate (DateTime): Birth date (converted to UTC)
- @MaritalStatus (string): Marital status code
- @Gender (string): Gender code

SQL Server Specific Functions/Syntax:
--------------------------------------
- DECLARE statement for variable declaration
- EXEC statement for stored procedure execution
- Stored procedure: [dbo].[uspUpdateAuthorPersonalInfo]
- Output parameter pattern: EXEC @variable = procedure
- Schema notation: [dbo].[procedureName]

Context:
--------
This statement calls a stored procedure to update author personal information.
The stored procedure is expected to return the number of rows affected.
Used in the Edit action when updating author records.

Stored Procedure Referenced:
-----------------------------
[dbo].[uspUpdateAuthorPersonalInfo]
Expected Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, 
                     @MaritalStatus, @Gender
Expected Return: Integer (rows affected)

================================================================================
Statement ID: 3
================================================================================
Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
Line Number: 208
Method Name: DeleteAuthorEmbeddedSql()
Statement Type: EXEC (Stored Procedure Call)
Return Type: bool (based on rows affected)

SQL Statement:
--------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

Parameter Definitions:
----------------------
- @BusinessEntityID (int): The business entity ID of the author to delete

SQL Server Specific Functions/Syntax:
--------------------------------------
- DECLARE statement for variable declaration
- EXEC statement for stored procedure execution
- Stored procedure: [dbo].[uspDeleteAuthor]
- Output parameter pattern: EXEC @variable = procedure
- Schema notation: [dbo].[procedureName]

Context:
--------
This statement calls a stored procedure to delete an author record.
The stored procedure is expected to return the number of rows affected.
Used in the Delete confirmation action when removing author records.

Stored Procedure Referenced:
-----------------------------
[dbo].[uspDeleteAuthor]
Expected Parameters: @BusinessEntityID
Expected Return: Integer (rows affected)

================================================================================
Statement ID: 4
================================================================================
Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
Line Number: 228
Method Name: SelectAuthorsByHireYear()
Statement Type: SELECT
Return Type: List<AuthorAgeResult>

SQL Statement:
--------------
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

Parameter Definitions:
----------------------
- @HireDate (int): The hire year to filter by

SQL Server Specific Functions/Syntax:
--------------------------------------
- FORMAT(date, format_string): SQL Server date formatting function
  * FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss')
  * Expected PostgreSQL equivalent: TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS')

- DATEDIFF(datepart, startdate, enddate): SQL Server date difference function
  * DATEDIFF(YEAR, BirthDate, GETDATE())
  * Expected PostgreSQL equivalent: DATE_PART('year', AGE(CURRENT_DATE, BirthDate))

- GETDATE(): SQL Server current date/time function
  * Expected PostgreSQL equivalent: CURRENT_DATE or NOW()

- DATEPART(datepart, date): SQL Server date part extraction function
  * DATEPART(YEAR, HireDate)
  * Expected PostgreSQL equivalent: EXTRACT(YEAR FROM HireDate)

- Schema notation: bobsbookstore_dbo.author

Context:
--------
This statement retrieves authors hired in a specific year with calculated fields:
- FormattedModifiedDate: Formatted modification date
- Age: Current age calculated from birth date
Filters by the year component of the HireDate column.

Result Type:
------------
AuthorAgeResult (custom type with properties: BusinessEntityID, 
FormattedModifiedDate, Age)

================================================================================
SUMMARY
================================================================================
Total Statements Extracted: 4
- SELECT statements: 2 (IDs: 1, 4)
- Stored Procedure calls: 2 (IDs: 2, 3)

Stored Procedures Referenced:
- [dbo].[uspUpdateAuthorPersonalInfo]
- [dbo].[uspDeleteAuthor]

SQL Server Functions Used:
- FORMAT() - 1 occurrence
- DATEDIFF() - 1 occurrence
- GETDATE() - 1 occurrence
- DATEPART() - 1 occurrence
- DECLARE - 2 occurrences
- EXEC - 2 occurrences

Schema References:
- bobsbookstore_dbo.author - 2 occurrences
- [dbo].[storedProcedure] - 2 occurrences

Complexity Assessment:
- Statement 1: EASY (simple SELECT *)
- Statement 2: MEDIUM (stored procedure with multiple parameters)
- Statement 3: MEDIUM (stored procedure with single parameter)
- Statement 4: HARD (complex SELECT with multiple SQL Server-specific functions)

================================================================================
Statement ID: 5
================================================================================
Source File: app/Bookstore.Web/Controllers/ProductsController.cs
Line Number: 31
Method Name: FindAllProducts()
Statement Type: EXEC (Stored Procedure Call)
Return Type: List<Product>

SQL Statement:
--------------
EXEC [dbo].[uspGetProductData];

Parameter Definitions:
----------------------
None

SQL Server Specific Functions/Syntax:
--------------------------------------
- EXEC statement for stored procedure execution
- Stored procedure: [dbo].[uspGetProductData]
- No parameters
- Schema notation: [dbo].[procedureName]

Context:
--------
This statement calls a stored procedure to retrieve all product data from the 
product table. The stored procedure is expected to return Product entity records.
Used in the Index action to populate the Products index page.

Stored Procedure Referenced:
-----------------------------
[dbo].[uspGetProductData]
Expected Parameters: None
Expected Return: Product records (ProductID, Name, ProductNumber, SafetyStockLevel)

================================================================================
SUMMARY UPDATE
================================================================================
Total Statements Extracted: 5 (Updated from 4)
- SELECT statements: 2 (IDs: 1, 4)
- Stored Procedure calls: 3 (IDs: 2, 3, 5)

Stored Procedures Referenced:
- [dbo].[uspUpdateAuthorPersonalInfo]
- [dbo].[uspDeleteAuthor]
- [dbo].[uspGetProductData] (NEW)

SQL Server Functions Used:
- FORMAT() - 1 occurrence
- DATEDIFF() - 1 occurrence
- GETDATE() - 1 occurrence
- DATEPART() - 1 occurrence
- DECLARE - 2 occurrences
- EXEC - 3 occurrences (Updated from 2)

Schema References:
- bobsbookstore_dbo.author - 2 occurrences
- [dbo].[storedProcedure] - 3 occurrences (Updated from 2)

Complexity Assessment:
- Statement 1: EASY (simple SELECT *)
- Statement 2: MEDIUM (stored procedure with multiple parameters)
- Statement 3: MEDIUM (stored procedure with single parameter)
- Statement 4: HARD (complex SELECT with multiple SQL Server-specific functions)
- Statement 5: MEDIUM (stored procedure with no parameters) (NEW)

Note: Statement 5 was discovered in Step 2 comprehensive audit and added to 
      maintain 100% SQL statement coverage per transformation definition.

================================================================================
END OF CATALOG
================================================================================
