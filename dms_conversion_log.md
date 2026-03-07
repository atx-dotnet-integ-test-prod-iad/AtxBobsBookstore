# DMS Conversion Log

## Migration Project Details
- **DMS ARN**: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- **Database**: BobsUsedBookStore
- **Region**: us-east-1
- **Source**: SQL Server (172.31.82.226)
- **Target**: PostgreSQL (atx-tgt-c04729758ce4430a87ec.cluster-curke6ks6gpf.us-east-1.rds.amazonaws.com)

---

## Statement 1: FindAllAuthorsEmbeddedSql

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | FindAllAuthorsEmbeddedSql() |
| **Original MS SQL** | `SELECT * FROM [dbo].[Author]` |
| **DMS Schema** | dbo |
| **DMS Model** | sql-conversion-1772897775 |
| **DMS Timestamp** | 2026-03-07T15:37:33.856954 |
| **DMS Status** | SUCCESS |
| **Converted PostgreSQL** | `SELECT * FROM bobsusedbookstore_dbo.author;` |
| **Notes** | DMS converted schema [dbo] to bobsusedbookstore_dbo, table [Author] to author (lowercase). |

---

## Statement 2: EditUsingStoredProcedure

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | EditUsingStoredProcedure() |
| **Original MS SQL** | `EXEC [HumanResources].[uspUpdateEmployeePersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender` |
| **DMS Schema** | HumanResources |
| **DMS Model** | sql-conversion-1772897859 |
| **DMS Timestamp** | 2026-03-07T15:38:57.442321 |
| **DMS Status** | SUCCESS |
| **Converted PostgreSQL** | `CALL HumanResources.uspUpdateEmployeePersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` |
| **Notes** | DMS converted EXEC to CALL, maintained HumanResources schema. Parameters wrapped in parentheses. |

---

## Statement 3: DeleteAuthorEmbeddedSql

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | DeleteAuthorEmbeddedSql() |
| **Original MS SQL** | `EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID` |
| **DMS Schema** | dbo |
| **DMS Model** | sql-conversion-1772897942 |
| **DMS Timestamp** | 2026-03-07T15:40:20.861933 |
| **DMS Status** | SUCCESS |
| **Converted PostgreSQL** | `CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);` |
| **Notes** | DMS converted EXEC to CALL, schema [dbo] to bobsusedbookstore_dbo, procedure name lowercased. |

---

## Statement 4: SelectAuthorsByHireYear

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | SelectAuthorsByHireYear() |
| **Original MS SQL** | `SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [HumanResources].[Employee] WHERE YEAR(HireDate) = @HireDate` |
| **DMS Schema** | HumanResources |
| **DMS Model** | sql-conversion-1772898026 |
| **DMS Timestamp** | 2026-03-07T15:41:44.613911 |
| **DMS Status** | SUCCESS |
| **Converted PostgreSQL** | `SELECT businessentityid, CAST (ModifiedDate AS VARCHAR(30)) AS formattedmodifieddate, datediff(year, BirthDate, clock_timestamp()) AS age FROM HumanResources.Employee WHERE date_part('year', HireDate::TIMESTAMP) = @HireDate;` |
| **Notes** | DMS converted CONVERT to CAST, DATEDIFF/GETDATE to datediff/clock_timestamp, YEAR() to date_part, column aliases lowercased. |

---

## Statement 5: FindAllProducts

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/ProductsController.cs |
| **Method** | FindAllProducts() |
| **Original MS SQL** | `EXEC [dbo].[uspGetProductData]` |
| **DMS Schema** | dbo |
| **DMS Model** | sql-conversion-1772898109 |
| **DMS Timestamp** | 2026-03-07T15:43:08.332092 |
| **DMS Status** | SUCCESS |
| **Converted PostgreSQL** | `CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);` |
| **Notes** | DMS converted EXEC to CALL, schema [dbo] to bobsusedbookstore_dbo, procedure name lowercased, added cursor parameter. |

---

## Summary

| Metric | Count |
|--------|-------|
| Total SQL Statements | 5 |
| DMS Successful Conversions | 5 |
| DMS Failed Conversions | 0 |
| Manual Conversions Required | 0 |
| Statements Re-integrated | 5 |
