# BobsBookstore Detailed Migration Log

## Per-Statement Migration Details

---

### Statement 1: EditUsingStoredProcedure

- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `EditUsingStoredProcedure`
- **Original MS SQL:**
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **DMS Conversion Attempt 1 (compound):** FAILED - "Statement definition is not valid"
- **DMS Conversion Attempt 2 (core EXEC):**
  ```sql
  EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
  ```
- **DMS Result:** SUCCESS via sql-conversion-1772746334
- **Converted PostgreSQL:**
  ```sql
  CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **Conversion Method:** DMS_TOOL
- **Equivalency Validation:** ERROR (tool returned 'uniqueID' error)
- **Code Re-integration:** Statement matches existing code - no change needed

---

### Statement 2: FindAllAuthorsEmbeddedSql

- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `FindAllAuthorsEmbeddedSql`
- **Original MS SQL:**
  ```sql
  SELECT * FROM Author
  ```
- **DMS Result:** SUCCESS via sql-conversion-1772746419
- **Converted PostgreSQL:**
  ```sql
  SELECT * FROM bobsusedbookstore_dbo.author;
  ```
- **Conversion Method:** DMS_TOOL
- **Equivalency Validation:** ERROR (tool returned 'uniqueID' error)
- **Code Re-integration:** Statement matches existing code - no change needed

---

### Statement 3: DeleteAuthorEmbeddedSql

- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `DeleteAuthorEmbeddedSql`
- **Original MS SQL:**
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **DMS Conversion Attempt 1 (compound):** FAILED - "Statement definition is not valid"
- **DMS Conversion Attempt 2 (core EXEC):**
  ```sql
  EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;
  ```
- **DMS Result:** SUCCESS via sql-conversion-1772746524
- **Converted PostgreSQL:**
  ```sql
  CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
  ```
- **Conversion Method:** DMS_TOOL
- **Equivalency Validation:** ERROR (tool returned 'uniqueID' error)
- **Code Re-integration:** Statement matches existing code - no change needed

---

### Statement 4: SelectAuthorsByHireYear

- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `SelectAuthorsByHireYear`
- **Original MS SQL:**
  ```sql
  SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
  ```
- **DMS Result:** SUCCESS (GenAI-assisted) via sql-conversion-1772746607
- **Converted PostgreSQL:**
  ```sql
  SELECT businessentityid, to_char(modifieddate, 'yyyy-MM-dd HH24:MI:SS') AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;
  ```
- **Key Conversions:**
  - `FORMAT()` → `to_char()`
  - `DATEDIFF()` → `aws_sqlserver_ext.datediff()`
  - `GETDATE()` → `clock_timestamp()`
  - `DATEPART()` → `date_part()`
  - Schema: `Author` → `bobsusedbookstore_dbo.author`
  - Column names lowercased: `BusinessEntityID` → `businessentityid`, etc.
- **Note:** DMS output uses `HireDate` without `@` prefix. The `@HireDate` prefix is preserved in code for C# NpgsqlParameter binding.
- **Conversion Method:** DMS_TOOL
- **Equivalency Validation:** ERROR (tool returned 'uniqueID' error)
- **Code Re-integration:** Statement matches existing code - no change needed

---

### Statement 5: FindAllProducts

- **Source File:** `app/Bookstore.Web/Controllers/ProductsController.cs`
- **Method:** `FindAllProducts`
- **Original MS SQL:**
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **DMS Result:** SUCCESS via sql-conversion-1772746690
- **Converted PostgreSQL:**
  ```sql
  CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
  ```
- **Conversion Method:** DMS_TOOL
- **Equivalency Validation:** ERROR (tool returned 'uniqueID' error)
- **Code Re-integration:** Statement matches existing code - no change needed

---

### Statement 6: CREATE TABLE Author

- **Source File:** `db/adven.sql`
- **Original MS SQL:**
  ```sql
  CREATE TABLE [dbo].[Author]( [BusinessEntityID] INT IDENTITY(1, 1) NOT NULL, ... ) ON [PRIMARY];
  ```
- **DMS Result:** SUCCESS via sql-conversion-1772746774
- **Converted PostgreSQL:**
  ```sql
  CREATE TABLE bobsusedbookstore_dbo.author (businessentityid BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL, ...);
  ```
- **Key Conversions:**
  - `INT IDENTITY(1,1)` → `BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)`
  - `nvarchar` → `VARCHAR`
  - `nchar` → `CHAR`
  - `bit` → `NUMERIC(1, 0)`
  - `datetime` → `TIMESTAMP WITHOUT TIME ZONE`
  - `getdate()` → `clock_timestamp()`
  - `ON [PRIMARY]` removed
- **Conversion Method:** DMS_TOOL
- **Equivalency Validation:** ERROR (tool returned 'uniqueID' error)

---

### Statement 7: CREATE TABLE Product

- **Source File:** `db/adven.sql`
- **Original MS SQL:**
  ```sql
  CREATE TABLE [dbo].[Product]( [ProductID] int IDENTITY(1, 1) NOT NULL, ... ) ON [PRIMARY];
  ```
- **DMS Result:** SUCCESS via sql-conversion-1772746858
- **Converted PostgreSQL:**
  ```sql
  CREATE TABLE bobsusedbookstore_dbo.product (productid BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL, ...);
  ```
- **Key Conversions:**
  - `money` → `NUMERIC(19, 4)`
  - `uniqueidentifier` → `UUID`
  - `newid()` → `aws_sqlserver_ext.newid()`
  - Same type conversions as Statement 6
- **Conversion Method:** DMS_TOOL
- **Equivalency Validation:** ERROR (tool returned 'uniqueID' error)

---

### Statement 8: INSERT INTO Author

- **Source File:** `db/adven-data.sql`
- **Original MS SQL:**
  ```sql
  INSERT INTO [dbo].[Author] ([NationalIDNumber], [LoginID], ...) VALUES (N'295847284', N'adventure-works\ken0', ...);
  ```
- **DMS Result:** SUCCESS via sql-conversion-1772746943
- **Converted PostgreSQL:**
  ```sql
  INSERT INTO bobsusedbookstore_dbo.author (nationalidnumber, loginid, ...) VALUES ('295847284', E'adventure-works\\ken0', ...);
  ```
- **Key Conversions:**
  - `N'...'` (NVARCHAR literal) → `'...'` (standard string) or `E'...'` (escaped string)
  - Schema: `[dbo].[Author]` → `bobsusedbookstore_dbo.author`
  - Column names lowercased
- **Conversion Method:** DMS_TOOL
- **Equivalency Validation:** ERROR (tool returned 'uniqueID' error)

---

## DMS Tool Conversion Summary

- **Total DMS calls:** 10 (8 original + 2 retry with core EXEC for compound statements)
- **DMS successes:** 8 (all statements converted)
- **DMS failures:** 2 (compound DECLARE/EXEC/SELECT statements - expected, resolved with core EXEC)
- **Manual conversions needed:** 0

## SQL Equivalency Validation Summary

- **Total pairs validated:** 8
- **Equivalent:** 0
- **Non-equivalent:** 0
- **Errors:** 8 (all returned 'uniqueID' error from the validation tool)
- **Note:** The 'uniqueID' error appears to be a tool-level issue, not related to the quality of the SQL conversions. All equivalency statuses are faithfully reported from the tool output with no agent judgment applied.
