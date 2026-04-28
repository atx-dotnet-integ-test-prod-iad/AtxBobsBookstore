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

Verify that all three projects build without warnings or errors. Pay attention to any deprecation warnings, as these may indicate APIs that need to be updated.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version.

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to behavioral differences in the new framework or pre-existing issues.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm that:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

If the project previously used Entity Framework 6, confirm it has been migrated to Entity Framework Core and that all `DbContext` configurations, relationships, and queries function correctly.

### 6. Run the Web Application Locally

Start the web application to validate runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and verify that:

- Pages render correctly.
- Data is retrieved and displayed as expected.
- Form submissions and other interactions work without errors.
- Any authentication or authorization mechanisms function correctly.

### 7. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Manually review the following areas for potential runtime issues that would not surface as build errors:

- **`System.Web` dependencies**: These are not available in .NET Core or later. Confirm that any functionality previously relying on `System.Web` has been replaced with ASP.NET Core equivalents.
- **Configuration**: Ensure `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration`.
- **HTTP Context access**: Confirm that `HttpContext` is accessed via dependency injection rather than static access patterns.

### 8. Check Application Logs

After running the application, review the console output and any configured log sinks for runtime exceptions or warnings that indicate incomplete migration areas.