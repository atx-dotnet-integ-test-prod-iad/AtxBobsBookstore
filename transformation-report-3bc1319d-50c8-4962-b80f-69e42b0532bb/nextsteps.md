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

Review the output for any warnings related to package compatibility or version conflicts. Address any packages that may have been targeting the old .NET Framework and verify their cross-platform equivalents are in place.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the build output for any warnings, even if there are no errors. Warnings related to deprecated APIs or nullable reference types may indicate areas that need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests targeting critical areas such as domain logic in `Bookstore.Domain` and data access in `Bookstore.Data`.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations or database configurations are functioning correctly:

```bash
dotnet ef dbcontext info --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the project previously used Entity Framework 6, confirm it has been migrated to Entity Framework Core and that all migrations are up to date.

### 5. Run the Web Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify that core functionality such as browsing, searching, and any data-driven pages are working as expected.

### 6. Review Configuration Files

Check `appsettings.json` in `Bookstore.Web` to confirm the following:

- Connection strings are correct and point to the intended database.
- Any configuration that previously lived in `Web.config` or `App.config` has been properly migrated to the `appsettings.json` format.
- Environment-specific settings are separated into `appsettings.Development.json` and `appsettings.Production.json` as appropriate.

### 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or dependencies that may not behave correctly on Linux or macOS. Common areas to check include:

- File path separators (use `Path.Combine` rather than hardcoded backslashes).
- Registry access, which is not available on non-Windows platforms.
- Windows Authentication or IIS-specific middleware configurations.

### 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all necessary files, static assets, and configuration files are present before deploying to the target environment.