# Connection String Migration Guide - SQL Server to PostgreSQL

## Overview
This document describes the connection string and configuration changes for the BobsBookstore application migration from Microsoft SQL Server to PostgreSQL.

## Current Configuration Status

### ✅ PostgreSQL Configuration Already In Place
The application has already been configured to use PostgreSQL with Npgsql. This migration focused on SQL statement conversion and code updates.

## Connection String Format

### SQL Server Connection String (Before)
```
Server=<server_address>;Database=<database_name>;User ID=<username>;Password=<password>;TrustServerCertificate=True;
```

### PostgreSQL Connection String (Current)
```
Host=<host_address>;Port=5432;Database=<database_name>;Username=<username>;Password=<password>;SSL Mode=Require;Trust Server Certificate=true;
```

## Configuration Files

### 1. appsettings.json
**Location:** `app/Bookstore.Web/appsettings.json`

**Current Configuration:**
- Uses AWS Secrets Manager for connection string storage
- Secret ARN: `arn:aws:secretsmanager:us-east-1:789616364195:secret:atx-db-modernization-jaabou-DBConnector-setup-bobsBookStoreDB-source-target-ExUSmt`
- Configuration key: `dbsecretsname`

**No changes required** - The connection string is retrieved from AWS Secrets Manager at runtime.

### 2. Program.cs and Startup Files
**Location:** `app/Bookstore.Web/Program.cs` and `app/Bookstore.Web/Startup/`

**Current Configuration:**
- Program.cs delegates to startup configuration classes
- ServicesSetup.cs configures DbContext with UseNpgsql

**Services Configuration** (`app/Bookstore.Web/Startup/ServicesSetup.cs`):
```csharp
builder.Services.AddDbContext<ApplicationDbContext>(option => option.UseNpgsql(connString));
```

**Status:** ✅ Already using UseNpgsql - No changes required

### 3. ApplicationDbContext
**Location:** `app/Bookstore.Data/ApplicationDbContext.cs`

**Current Configuration:**
```csharp
AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
```

**Status:** ✅ Already configured for PostgreSQL timestamp handling

## Connection String Parameters Mapping

| SQL Server Parameter | PostgreSQL Parameter | Notes |
|---------------------|---------------------|-------|
| Server= | Host= | PostgreSQL uses Host instead of Server |
| Port (default 1433) | Port=5432 | PostgreSQL default port is 5432 |
| Database= | Database= | Same parameter name |
| User ID= | Username= | PostgreSQL uses Username |
| Password= | Password= | Same parameter name |
| Integrated Security=true | N/A | PostgreSQL uses username/password auth |
| TrustServerCertificate= | Trust Server Certificate= | Similar functionality |
| N/A | SSL Mode=Require | PostgreSQL-specific SSL configuration |

## Database Schema Configuration

### Schema Mapping
The application uses the schema `bobsbookstore_dbo` for all tables, mapped in ApplicationDbContext:

```csharp
entity.ToTable("author", "bobsbookstore_dbo");
entity.ToTable("book", "bobsbookstore_dbo");
entity.ToTable("customer", "bobsbookstore_dbo");
// ... etc
```

**Status:** ✅ Schema mappings already configured

## AWS Secrets Manager Integration

### Connection String Retrieval
The application retrieves the PostgreSQL connection string from AWS Secrets Manager at runtime:

**Secret ARN:**
```
arn:aws:secretsmanager:us-east-1:789616364195:secret:atx-db-modernization-jaabou-DBConnector-setup-bobsBookStoreDB-source-target-ExUSmt
```

### Secret Format
The secret should contain a JSON object with the connection string:
```json
{
  "connectionString": "Host=<host>;Port=5432;Database=<db>;Username=<user>;Password=<pass>;SSL Mode=Require;Trust Server Certificate=true"
}
```

## NuGet Package Configuration

### PostgreSQL Packages (Current)
**Location:** `app/Bookstore.Data/Bookstore.Data.csproj`

```xml
<PackageReference Include="Npgsql" Version="8.0.3" />
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="8.0.4" />
```

**Status:** ✅ Already using Npgsql packages

### SQL Server Packages (Removed)
No SQL Server specific packages remain in the project.

## Connection Pooling

### PostgreSQL Connection Pooling
Npgsql includes built-in connection pooling. Additional parameters can be added to the connection string:

```
Host=<host>;Port=5432;Database=<db>;Username=<user>;Password=<pass>;Minimum Pool Size=0;Maximum Pool Size=100;Connection Lifetime=0;
```

**Current Status:** Using Npgsql default connection pooling settings

## Timestamp Behavior

### Npgsql Legacy Timestamp Behavior
The application enables legacy timestamp behavior for backward compatibility:

```csharp
AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
```

This ensures DateTime values are handled consistently when migrating from SQL Server.

## Verification Checklist

✅ **Connection String Format:** PostgreSQL format with Host, Port, Username parameters  
✅ **DbContext Configuration:** Using UseNpgsql instead of UseSqlServer  
✅ **Package References:** Npgsql and Npgsql.EntityFrameworkCore.PostgreSQL installed  
✅ **Schema Mappings:** All tables mapped to bobsbookstore_dbo schema  
✅ **Timestamp Behavior:** EnableLegacyTimestampBehavior enabled  
✅ **AWS Secrets Manager:** Connection string stored securely  
✅ **No SQL Server Dependencies:** No Microsoft.Data.SqlClient or System.Data.SqlClient references  

## Infrastructure Requirements

### Database Setup
1. PostgreSQL database instance must be running
2. Database name must match the connection string
3. Schema `bobsbookstore_dbo` must exist
4. All required tables must be created with correct schema
5. PostgreSQL functions must be deployed:
   - `bobsbookstore_dbo.uspUpdateAuthorPersonalInfo`
   - `bobsbookstore_dbo.uspDeleteAuthor`
   - `bobsbookstore_dbo.uspGetProductData`

### AWS Infrastructure
1. AWS Secrets Manager secret must contain valid PostgreSQL connection string
2. Application IAM role must have permission to read the secret
3. Network connectivity from application to PostgreSQL database must be configured
4. Security groups must allow PostgreSQL port 5432

## Environment-Specific Considerations

### Development
- Connection string can be in appsettings.Development.json for local development
- Consider using local PostgreSQL instance for development

### Staging/Production
- Always use AWS Secrets Manager for connection strings
- Enable SSL Mode=Require for production
- Configure appropriate connection pool sizes based on load
- Monitor connection pool metrics

## Migration Completion Status

All connection string and configuration changes have been verified:

✅ Application uses UseNpgsql for database context  
✅ Connection strings use PostgreSQL format  
✅ AWS Secrets Manager integration in place  
✅ No SQL Server specific configuration remains  
✅ Application builds successfully with PostgreSQL configuration  

**No additional configuration changes required.**

## Next Steps

1. Ensure PostgreSQL database is running with correct schema
2. Verify AWS Secrets Manager secret contains valid connection string
3. Deploy PostgreSQL functions (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
4. Run application and verify database connectivity
5. Execute integration tests to validate SQL statement conversions
6. Monitor application logs for any database-related errors

## Support and Troubleshooting

### Common Issues

**Issue:** Application cannot connect to PostgreSQL  
**Solution:** Verify connection string in AWS Secrets Manager, check network connectivity, validate security groups

**Issue:** SSL certificate errors  
**Solution:** Add `Trust Server Certificate=true` to connection string or configure proper SSL certificates

**Issue:** Function not found errors  
**Solution:** Ensure all PostgreSQL functions are deployed to the database

**Issue:** Schema not found errors  
**Solution:** Verify schema `bobsbookstore_dbo` exists in PostgreSQL database

## References

- [Npgsql Documentation](https://www.npgsql.org/doc/index.html)
- [Entity Framework Core with PostgreSQL](https://www.npgsql.org/efcore/index.html)
- [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/)
- [PostgreSQL Connection Strings](https://www.npgsql.org/doc/connection-string-parameters.html)

---

**Document Version:** 1.0  
**Last Updated:** 2026-02-07  
**Migration Status:** Complete
