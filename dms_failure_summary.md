# DMS Conversion Failure Summary
## Migration: SQL Server to PostgreSQL - BobsBookstore

### Overview
All 5 SQL statements were submitted to the DMS MCP tool (dms-mcp___statement_conversion_tool) for conversion.
All 5 statements failed with the same error. Manual conversion was applied using lowercase schema object names
per the transformation definition rules (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA).

### DMS Configuration Used
- Migration Project ARN: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- Database Name: BobsBookstore
- Schema Name: dbo
- Region: us-east-1
- Server Name: 172.31.82.226 (auto-detected)

### Common DMS Error
All statements returned the same error:
```
Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
```

### Statement-by-Statement Details

---

#### Statement 1: EditUsingStoredProcedure (AuthorsController.cs line 165)
**Original (T-SQL):**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
```

**DMS Output:** Error - Metadata model creation failed (see common error above)

**Manual Conversion (PostgreSQL):**
```sql
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
```

**Conversion Notes:**
- DECLARE/EXEC/SELECT pattern replaced with direct function call
- Schema [dbo] mapped to bobsbookstore_dbo (matching ApplicationDbContext schema)
- Stored procedure name converted to lowercase

---

#### Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs line 190)
**Original (T-SQL):**
```sql
SELECT * FROM Author
```

**DMS Output:** Error - Metadata model creation failed (see common error above)

**Manual Conversion (PostgreSQL):**
```sql
SELECT * FROM bobsbookstore_dbo.author
```

**Conversion Notes:**
- Table name 'Author' converted to lowercase 'author'
- Schema qualification added: bobsbookstore_dbo

---

#### Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs line 213)
**Original (T-SQL):**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
```

**DMS Output:** Error - Metadata model creation failed (see common error above)

**Manual Conversion (PostgreSQL):**
```sql
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
```

**Conversion Notes:**
- DECLARE/EXEC/SELECT pattern replaced with direct function call
- Schema [dbo] mapped to bobsbookstore_dbo
- Stored procedure name converted to lowercase

---

#### Statement 4: SelectAuthorsByHireYear (AuthorsController.cs line 234)
**Original (T-SQL):**
```sql
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
```

**DMS Output:** Error - Metadata model creation failed (see common error above)

**Manual Conversion (PostgreSQL):**
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
```

**Conversion Notes:**
- FORMAT() → TO_CHAR() with PostgreSQL format string
- DATEDIFF(YEAR, BirthDate, GETDATE()) → EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT
- DATEPART(YEAR, HireDate) → EXTRACT(YEAR FROM hiredate)
- GETDATE() → NOW()
- All column names converted to lowercase
- Table 'Author' → bobsbookstore_dbo.author

---

#### Statement 5: FindAllProducts (ProductsController.cs line 36)
**Original (T-SQL):**
```sql
EXEC [dbo].[uspGetProductData];
```

**DMS Output:** Error - Metadata model creation failed (see common error above)

**Manual Conversion (PostgreSQL):**
```sql
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
```

**Conversion Notes:**
- EXEC pattern converted to SELECT * FROM function call
- Schema [dbo] mapped to bobsbookstore_dbo
- Stored procedure name converted to lowercase
