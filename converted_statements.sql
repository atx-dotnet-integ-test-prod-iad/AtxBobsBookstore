===============================================================================
CONVERTED SQL STATEMENTS - PostgreSQL Syntax
===============================================================================
Project: Bob's Bookstore ADO.NET Application
Conversion Date: 2026-02-10
Total Statements Converted: 5
Conversion Method: MANUAL_AFTER_DMS_FAILURE (all 5 statements)
===============================================================================

NOTE: All statements were attempted through DMS MCP tool first. Due to DMS
tool errors (metadata model creation failed), manual conversions were applied
based on PostgreSQL best practices. See dms_conversion_failures.log for
detailed DMS error information.

===============================================================================

===============================================================================
STATEMENT 1: EditUsingStoredProcedure
===============================================================================
SOURCE: app/Bookstore.Web/Controllers/AuthorsController.cs
METHOD: EditUsingStoredProcedure
LINE: ~163
CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
PARAMETERS: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)

ORIGINAL SQL SERVER:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

CONVERTED POSTGRESQL:
DO $$
DECLARE rowsAffected INT;
BEGIN
  SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(
    @BusinessEntityID, 
    @NationalIDNumber, 
    @BirthDate, 
    @MaritalStatus, 
    @Gender
  ) INTO rowsAffected;
  SELECT rowsAffected;
END $$;
===============================================================================


===============================================================================
STATEMENT 2: FindAllAuthorsEmbeddedSql
===============================================================================
SOURCE: app/Bookstore.Web/Controllers/AuthorsController.cs
METHOD: FindAllAuthorsEmbeddedSql
LINE: ~189
CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
PARAMETERS: None

ORIGINAL SQL SERVER:
SELECT * FROM bobsbookstore_dbo.author

CONVERTED POSTGRESQL:
SELECT * FROM bobsbookstore_dbo.author
===============================================================================


===============================================================================
STATEMENT 3: DeleteAuthorEmbeddedSql
===============================================================================
SOURCE: app/Bookstore.Web/Controllers/AuthorsController.cs
METHOD: DeleteAuthorEmbeddedSql
LINE: ~208
CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
PARAMETERS: @BusinessEntityID (int)

ORIGINAL SQL SERVER:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

CONVERTED POSTGRESQL:
DO $$
DECLARE rowsAffected INT;
BEGIN
  SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID) INTO rowsAffected;
  SELECT rowsAffected;
END $$;
===============================================================================


===============================================================================
STATEMENT 4: SelectAuthorsByHireYear
===============================================================================
SOURCE: app/Bookstore.Web/Controllers/AuthorsController.cs
METHOD: SelectAuthorsByHireYear
LINE: ~228
CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
PARAMETERS: @HireDate (int - hire year)

ORIGINAL SQL SERVER:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

CONVERTED POSTGRESQL:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
===============================================================================


===============================================================================
STATEMENT 5: FindAllProducts
===============================================================================
SOURCE: app/Bookstore.Web/Controllers/ProductsController.cs
METHOD: FindAllProducts
LINE: ~32
CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
PARAMETERS: None

ORIGINAL SQL SERVER:
EXEC [dbo].[uspGetProductData];

CONVERTED POSTGRESQL:
SELECT * FROM bobsbookstore_dbo.uspGetProductData();
===============================================================================


===============================================================================
SUMMARY OF POSTGRESQL CONVERSIONS
===============================================================================
Total Statements: 5
- DECLARE blocks converted to PostgreSQL syntax with DO $$ blocks: 2
- EXEC stored procedures converted to SELECT/function calls: 3
- Direct SELECT queries (already compatible): 1
- SQL Server functions converted to PostgreSQL equivalents: 1
  - FORMAT() → TO_CHAR()
  - DATEDIFF() → EXTRACT(YEAR FROM AGE())
  - GETDATE() → CURRENT_DATE
  - DATEPART() → EXTRACT()

Schema Handling:
- All references use schema-qualified names: bobsbookstore_dbo
- No schema name changes from DMS (manual conversion maintained original schema names)
- [dbo] brackets removed (PostgreSQL uses unbracketed schema names)

Parameter Handling:
- @ prefixed parameters maintained (Npgsql handles parameter mapping)
- No conversion to $1, $2 positional parameters (named parameters supported)

Next Step: Validate equivalency of all 5 statement pairs using SQL Equivalency MCP tool
===============================================================================
