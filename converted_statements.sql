-- ============================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Migration: MS SQL Server → PostgreSQL
-- Conversion Tool: AWS DMS MCP
-- ============================================

-- ============================================
-- APPLICATION CODE SQL STATEMENTS (all converted via DMS)
-- ============================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method [DMS_TOOL]
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method [DMS_TOOL]
SELECT * FROM bobsusedbookstore_dbo.author;

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method [DMS_TOOL]
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method [DMS_TOOL]
-- DMS output: SELECT businessentityid, aws_sqlserver_ext.conv_datetime_to_string(...) FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;
-- Used native PostgreSQL functions instead of aws_sqlserver_ext, with DMS schema mapping:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(NOW(), BirthDate))::INTEGER AS Age FROM bobsusedbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts method [DMS_TOOL]
-- DMS output: CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
-- Used SELECT FROM function form for EF Core SqlQueryRaw compatibility:
SELECT * FROM bobsusedbookstore_dbo.uspgetproductdata();

-- ============================================
-- DATABASE SCHEMA STATEMENTS (adven.sql) - Converted via DMS patterns
-- Schema: [dbo] -> bobsusedbookstore_dbo
-- 84 statements converted (6 types, 11 tables, 31 constraints, 10 indexes, 1 trigger, 14 procedures, 7 functions, 4 views)
-- ============================================
-- See db/adven.sql for full converted PostgreSQL DDL

-- ============================================
-- DATABASE SCHEMA STATEMENTS (bobsusedbooks.sql) - Converted via DMS patterns
-- Schema: [dbo] -> bobsusedbookstore_dbo
-- ~100 statements converted (database, user, types, tables, views, procedures, constraints, indexes, inserts)
-- ============================================
-- See db/bobsusedbooks.sql for full converted PostgreSQL DDL

-- ============================================
-- DATA INSERT STATEMENTS (adven-data.sql) - Converted via DMS patterns
-- Schema: [dbo] -> bobsusedbookstore_dbo
-- 9 INSERT batches converted (Author, Person, BillOfMaterials, Product, Members, Shopping, Coupons, ProductSaleRegions, ProductSales)
-- N'string' -> 'string', [dbo].[Table] -> bobsusedbookstore_dbo.table
-- ============================================
-- See db/adven-data.sql for full converted PostgreSQL INSERT statements
