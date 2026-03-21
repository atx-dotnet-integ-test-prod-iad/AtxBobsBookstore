# DMS Conversion Failure Summary
# Date: 2026-03-20
# Migration Project ARN: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U

## All 5 statements failed DMS conversion with the same error:
Error: "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}\"}"

## Statement 1: FindAllAuthorsEmbeddedSql
- Original: SELECT * FROM bobsbookstore_dbo.author
- DMS Output: ERROR - Metadata model creation failed
- Manual Conversion: SELECT * FROM bobsbookstore_dbo.author
- Conversion Reason: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

## Statement 2: EditUsingStoredProcedure
- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
- DMS Output: ERROR - Metadata model creation failed
- Manual Conversion: SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
- Conversion Reason: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

## Statement 3: DeleteAuthorEmbeddedSql
- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
- DMS Output: ERROR - Metadata model creation failed
- Manual Conversion: SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
- Conversion Reason: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

## Statement 4: SelectAuthorsByHireYear
- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
- DMS Output: ERROR - Metadata model creation failed
- Manual Conversion: SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
- Conversion Reason: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

## Statement 5: FindAllProducts
- Original: EXEC [dbo].[uspGetProductData];
- DMS Output: ERROR - Metadata model creation failed
- Manual Conversion: SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
- Conversion Reason: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
