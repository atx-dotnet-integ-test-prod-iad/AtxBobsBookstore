-- Converted SQL Statements for PostgreSQL - BobsBookstore Application
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Date: 2026-03-26
-- Note: All statements were already using lowercase schema object names and PostgreSQL-compatible syntax.
-- Manual conversion applied lowercase schema mapping rules per transformation definition.

-- Statement 1: EditUsingStoredProcedure - AuthorsController.cs line 163
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion: dbo schema prefix retained, function name already lowercase
SELECT dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql - AuthorsController.cs line 187
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion: Table name already lowercase
SELECT * FROM author;

-- Statement 3: DeleteAuthorEmbeddedSql - AuthorsController.cs line 208
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion: dbo schema prefix retained, function name already lowercase
SELECT dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear - AuthorsController.cs line 228
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion: All column names and table name already lowercase, PostgreSQL functions already used
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM NOW())::INT - EXTRACT(YEAR FROM birthdate)::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts - ProductsController.cs line 34
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Conversion: dbo schema prefix retained, function name already lowercase
SELECT * FROM dbo.uspgetproductdata();
