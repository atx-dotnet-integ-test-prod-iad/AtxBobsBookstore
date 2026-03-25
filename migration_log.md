# Migration Log: SQL Server to PostgreSQL
## BobsBookstore .NET Application - Detailed Per-Statement Documentation

### Statement 1: EditUsingStoredProcedure
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Source Method**: `EditUsingStoredProcedure`
- **Source Line**: ~165
- **Statement Type**: Stored Procedure EXEC call with parameters

#### Original MS SQL
```sql
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
```

#### DMS Conversion Attempts
- **Attempt #1 Timestamp**: 2026-03-25T01:14:26
- **Attempt #1 Status**: FAILED
- **Attempt #2 Timestamp**: 2026-03-25T01:44:50
- **Attempt #2 Status**: FAILED
- **Error**: Metadata model creation failed: No objects were found according to the specified selection rules.
- **DMS Parameters**: database_name=BobsBookstore, schema_name=dbo, region=us-east-1

#### Manual Conversion (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)
```sql
UPDATE bobsbookstore_dbo.author SET nationalidnumber = @NationalIDNumber, birthdate = @BirthDate, maritalstatus = @MaritalStatus, gender = @Gender WHERE businessentityid = @BusinessEntityID
```

#### Conversion Notes
- Stored procedure `[dbo].[uspUpdateAuthorPersonalInfo]` replaced with direct UPDATE statement
- All schema objects converted to lowercase per PostgreSQL convention
- Schema prefix changed from `[dbo]` to `bobsbookstore_dbo`
- Parameters retained with original names for NpgsqlParameter binding

#### SQL Equivalency Validation
- **Timestamp**: 2026-03-25T01:48:37
- **Status**: ERROR
- **Tool Output**: `{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-25T01:48:37.077484"}`

---

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Source Method**: `FindAllAuthorsEmbeddedSql`
- **Source Line**: ~192
- **Statement Type**: Simple SELECT query

#### Original MS SQL
```sql
SELECT * FROM [dbo].[Author]
```

#### DMS Conversion Attempts
- **Attempt #1 Timestamp**: 2026-03-25T01:14:48
- **Attempt #1 Status**: FAILED
- **Attempt #2 Timestamp**: 2026-03-25T01:45:14
- **Attempt #2 Status**: FAILED
- **Error**: Metadata model creation failed: No objects were found according to the specified selection rules.
- **DMS Parameters**: database_name=BobsBookstore, schema_name=dbo, region=us-east-1

#### Manual Conversion (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)
```sql
SELECT * FROM bobsbookstore_dbo.author
```

#### Conversion Notes
- Table name `[Author]` converted to lowercase `author`
- Schema prefix changed from `[dbo]` to `bobsbookstore_dbo`

#### SQL Equivalency Validation
- **Timestamp**: 2026-03-25T01:48:47
- **Status**: ERROR
- **Tool Output**: `{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-25T01:48:47.182035"}`

---

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Source Method**: `DeleteAuthorEmbeddedSql`
- **Source Line**: ~207
- **Statement Type**: Stored Procedure EXEC call with parameter

#### Original MS SQL
```sql
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
```

#### DMS Conversion Attempts
- **Attempt #1 Timestamp**: 2026-03-25T01:15:10
- **Attempt #1 Status**: FAILED
- **Attempt #2 Timestamp**: 2026-03-25T01:45:35
- **Attempt #2 Status**: FAILED
- **Error**: Metadata model creation failed: No objects were found according to the specified selection rules.
- **DMS Parameters**: database_name=BobsBookstore, schema_name=dbo, region=us-east-1

#### Manual Conversion (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)
```sql
DELETE FROM bobsbookstore_dbo.author WHERE businessentityid = @BusinessEntityID
```

#### Conversion Notes
- Stored procedure `[dbo].[uspDeleteAuthor]` replaced with direct DELETE statement
- All schema objects converted to lowercase per PostgreSQL convention
- Schema prefix changed from `[dbo]` to `bobsbookstore_dbo`
- Parameter retained with original name for NpgsqlParameter binding

#### SQL Equivalency Validation
- **Timestamp**: 2026-03-25T01:48:56
- **Status**: ERROR
- **Tool Output**: `{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-25T01:48:56.526477"}`

---

### Statement 4: SelectAuthorsByHireYear
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Source Method**: `SelectAuthorsByHireYear`
- **Source Line**: ~229
- **Statement Type**: SELECT with SQL Server-specific functions

#### Original MS SQL
```sql
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEPART(YEAR, HireDate) = @HireDate
```

#### DMS Conversion Attempts
- **Attempt #1 Timestamp**: 2026-03-25T01:15:32
- **Attempt #1 Status**: FAILED
- **Attempt #2 Timestamp**: 2026-03-25T01:45:58
- **Attempt #2 Status**: FAILED
- **Error**: Metadata model creation failed: No objects were found according to the specified selection rules.
- **DMS Parameters**: database_name=BobsBookstore, schema_name=dbo, region=us-east-1

#### Manual Conversion (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate
```

#### Conversion Notes
- `FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss')` → `TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')`
- `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT`
- `GETDATE()` → `NOW()`
- `DATEPART(YEAR, HireDate)` → `EXTRACT(YEAR FROM hiredate)`
- All column names and table names converted to lowercase
- Schema prefix changed from `[dbo]` to `bobsbookstore_dbo`

#### SQL Equivalency Validation
- **Timestamp**: 2026-03-25T01:49:07
- **Status**: ERROR
- **Tool Output**: `{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-25T01:49:07.575339"}`

---

### Statement 5: FindAllProducts
- **Source File**: `app/Bookstore.Web/Controllers/ProductsController.cs`
- **Source Method**: `FindAllProducts`
- **Source Line**: ~36
- **Statement Type**: Stored Procedure EXEC call (no parameters)

#### Original MS SQL
```sql
EXEC [dbo].[uspGetProductData]
```

#### DMS Conversion Attempts
- **Attempt #1 Timestamp**: 2026-03-25T01:15:54
- **Attempt #1 Status**: FAILED
- **Attempt #2 Timestamp**: 2026-03-25T01:46:21
- **Attempt #2 Status**: FAILED
- **Error**: Metadata model creation failed: No objects were found according to the specified selection rules.
- **DMS Parameters**: database_name=BobsBookstore, schema_name=dbo, region=us-east-1

#### Manual Conversion (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)
```sql
SELECT productid, name, productnumber, safetystocklevel FROM bobsbookstore_dbo.product
```

#### Conversion Notes
- Stored procedure `[dbo].[uspGetProductData]` replaced with direct SELECT statement
- Column names match the Product entity model: productid, name, productnumber, safetystocklevel
- All schema objects converted to lowercase per PostgreSQL convention
- Schema prefix changed from `[dbo]` to `bobsbookstore_dbo`

#### SQL Equivalency Validation
- **Timestamp**: 2026-03-25T01:49:16
- **Status**: ERROR
- **Tool Output**: `{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-25T01:49:16.617456"}`

---

### DMS Tool Configuration Used
```json
{
  "migration_project_identifier": "arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U",
  "database_name": "BobsBookstore",
  "schema_name": "dbo",
  "region": "us-east-1",
  "server_name": "172.31.82.226"
}
```

### Additional Changes

#### Order Entity Table Mapping Fix
- **File**: `app/Bookstore.Data/ApplicationDbContext.cs`
- **Change**: `entity.ToTable("Order", "bobsbookstore_dbo")` → `entity.ToTable("order", "bobsbookstore_dbo")`
- **Reason**: Consistency with lowercase convention used by all other entity table mappings
