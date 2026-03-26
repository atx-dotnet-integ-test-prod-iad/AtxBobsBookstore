-- Extracted SQL Statements from BobsBookstore Application
-- Source: Microsoft SQL Server to PostgreSQL Migration
-- Date: 2026-03-26

-- Statement 1: EditUsingStoredProcedure - AuthorsController.cs line 163
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql - AuthorsController.cs line 187
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT * FROM author;

-- Statement 3: DeleteAuthorEmbeddedSql - AuthorsController.cs line 208
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear - AuthorsController.cs line 228
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM NOW())::INT - EXTRACT(YEAR FROM birthdate)::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts - ProductsController.cs line 34
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
SELECT * FROM dbo.uspgetproductdata();
