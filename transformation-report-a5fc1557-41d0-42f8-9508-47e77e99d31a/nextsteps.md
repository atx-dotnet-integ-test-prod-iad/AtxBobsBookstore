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

If the solution contains any test projects, execute them to validate that existing logic has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review test results and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All pages and routes load correctly.
- Database connectivity functions as expected (if applicable).
- Any data access operations through `Bookstore.Data` and `Bookstore.Domain` execute without errors.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 6. Check for Removed or Changed APIs

Review any usages of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Pay particular attention to:

- `System.Web` namespaces, which are not available in cross-platform .NET.
- Any Windows-specific APIs that may compile but fail at runtime on non-Windows platforms.
- Entity Framework version compatibility if `Bookstore.Data` uses database access.

### 7. Review Configuration Files

Confirm that configuration has been migrated from `Web.config` or `App.config` to the appropriate `appsettings.json` format, and that the application reads configuration correctly at runtime using `Microsoft.Extensions.Configuration`.

### 8. Validate Data Layer

If `Bookstore.Data` interacts with a database, verify the following:

- Connection strings are correctly defined in `appsettings.json`.
- Any Entity Framework migrations are up to date and can be applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 9. Test on Target Platform

If the goal is cross-platform compatibility, run the application on the intended non-Windows platform (Linux or macOS) to surface any platform-specific runtime issues that would not appear during a Windows build.