# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated as part of the migration.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while not blocking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, verify the following:

- **Database provider**: Confirm that the Entity Framework Core (or whichever ORM is in use) provider is compatible with the target database. For example, if SQL Server is used, ensure `Microsoft.EntityFrameworkCore.SqlServer` is referenced.
- **Migrations**: If EF Core migrations are present, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- **Connection strings**: Confirm that connection strings in `appsettings.json` are correctly configured for the target environment, as `Web.config`-based configuration is no longer used in cross-platform .NET.

### 5. Verify Configuration Migration

Legacy .NET Framework projects rely on `Web.config` and `App.config`. Cross-platform .NET uses `appsettings.json`. Confirm the following:

- All configuration values previously in `Web.config` (connection strings, app settings, etc.) have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Any code referencing `System.Configuration.ConfigurationManager` has been updated to use `Microsoft.Extensions.Configuration`.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project locally to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify:

- Pages load without errors.
- Database reads and writes function correctly.
- Authentication and authorization (if applicable) behave as expected.

### 7. Review Middleware and HTTP Pipeline

If the project was migrated from ASP.NET (System.Web) to ASP.NET Core, review `Program.cs` and/or `Startup.cs` to ensure:

- Middleware is registered in the correct order.
- Static files, routing, authentication, and session middleware are all present if they were used in the original project.

### 8. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but are not available or behave differently in cross-platform .NET:

- `System.Web` references (should be fully removed).
- Windows-specific APIs such as the registry, Windows identity impersonation, or COM interop, if cross-platform support is required.
- Any use of `AppDomain` APIs that have limited support in .NET Core and later.