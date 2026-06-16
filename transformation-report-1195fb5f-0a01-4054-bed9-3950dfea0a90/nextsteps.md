# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any compile-time errors:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations or database configurations are functioning correctly.

If using Entity Framework Core, verify your migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to confirm runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL provided in the console output and verify the following:

- The application loads without runtime exceptions
- Core features such as browsing, searching, and managing books function as expected
- Any authentication or authorization flows work correctly

### 6. Review Configuration Files

Check `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` to ensure the following have been updated for the new .NET target:

- Connection strings reference the correct database server and credentials
- Any legacy `web.config` or `app.config` settings have been migrated to the appropriate `appsettings.json` entries
- Logging configuration is correct for the target environment

### 7. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` element reflects the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues.

### 8. Check for Removed or Changed APIs

Review the code in each project for any usage of APIs that were removed or significantly changed in the target .NET version. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET and should have been replaced with `Microsoft.AspNetCore` equivalents
- Any `HttpContext` or `HttpRequest` usage that may require adjustment
- Any Windows-specific APIs that may not function on Linux or macOS

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can assist in identifying remaining compatibility concerns.