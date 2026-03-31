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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that the output reports zero errors and review any warnings that may indicate deprecated APIs or framework incompatibilities.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration.

### 4. Verify Entity Framework Migrations (if applicable)

Since the solution includes a `Bookstore.Data` project, verify that any Entity Framework Core migrations are intact and functional:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of date, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations to a test database to confirm schema generation works as expected:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry features, to confirm end-to-end functionality.

### 6. Review Configuration Files

Inspect `appsettings.json` and `appsettings.Production.json` in `Bookstore.Web` to confirm the following:

- Connection strings are updated and valid for the target environment.
- Any configuration keys that were previously stored in `Web.config` have been correctly migrated to the new `appsettings.json` format.
- Environment-specific settings are correctly separated.

### 7. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 8. Review Deprecated or Removed APIs

Search the codebase for any usages of APIs that existed in .NET Framework but have changed or been removed in modern .NET. Pay particular attention to:

- `System.Web` namespace usages, which are not available in cross-platform .NET.
- `HttpContext` and related types, which should now come from `Microsoft.AspNetCore.Http`.
- Any Windows-specific APIs that may not be available on Linux or macOS.

### 9. Deployment

Once local validation is complete, publish the application using the following command:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, views, and static files are present before deploying to the target environment.