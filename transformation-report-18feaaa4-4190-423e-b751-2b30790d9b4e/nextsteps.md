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

Run a full solution build to confirm the absence of errors:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build with zero errors and zero warnings, or investigate any warnings that may indicate compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Review Removed or Changed APIs

Check for any usage of APIs that were available in .NET Framework but have changed behavior or been removed in cross-platform .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- Windows-specific APIs such as the registry, WCF server-side components, or `System.Drawing` (GDI+)
- Any third-party NuGet packages that may still target .NET Framework only

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to assist with this review.

### 6. Run the Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and confirm that:

- Pages load without errors
- Database connectivity is functioning (if applicable)
- Any authentication or authorization flows work as expected

### 7. Verify Database Migrations

If the `Bookstore.Data` project uses Entity Framework Core, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a local database instance:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files contain the correct values, particularly for:

- Connection strings
- Logging configuration
- Any settings that were previously stored in `Web.config` or `App.config`

Ensure that `Web.config` transformation logic has been replaced with the appropriate `appsettings.json` or environment variable approach.