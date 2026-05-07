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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target framework version.
- Connection strings in configuration files (`appsettings.json`) are correct and accessible in the new environment.
- Any Entity Framework migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and exercise the primary features to confirm expected behavior, paying particular attention to:

- Routing and page rendering
- Data reads and writes through `Bookstore.Data`
- Any authentication or session handling that may behave differently under cross-platform .NET

### 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Review the [.NET Upgrade Assistant compatibility analyzer output](https://learn.microsoft.com/en-us/dotnet/core/porting/) or run the API compatibility analyzer to surface any runtime-only issues that did not produce build errors:

```bash
dotnet add package Microsoft.DotNet.ApiCompat
```

### 8. Check Configuration System

.NET no longer uses `System.Configuration` (`app.config` / `web.config`) in the same way. Confirm that all configuration values previously read via `ConfigurationManager` have been migrated to the `Microsoft.Extensions.Configuration` system using `appsettings.json` or environment variables.

### 9. Publish the Application

Once local validation is complete, produce a published output to verify the deployment artifact builds correctly:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and dependencies are present before deploying to the target environment.