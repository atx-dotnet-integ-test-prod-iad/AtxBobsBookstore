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

Verify that all three projects build without warnings or errors.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test output for any failures that may indicate behavioral regressions introduced during the migration.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup completes without exceptions
- Database connectivity works as expected through `Bookstore.Data`
- Domain logic in `Bookstore.Domain` behaves correctly end-to-end
- All major routes and pages in `Bookstore.Web` load and respond correctly

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Review any usages of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Pay particular attention to:

- `System.Web` usages, which are not available in cross-platform .NET
- `HttpContext` and related types, which have different namespaces and behaviors in ASP.NET Core
- Any Windows-specific APIs that may compile but fail at runtime on non-Windows platforms

### 7. Review Configuration Files

Confirm that `web.config` has been replaced or supplemented by `appsettings.json` and that the application reads configuration correctly using the `Microsoft.Extensions.Configuration` APIs. Verify connection strings and application settings are present and accurate.

### 8. Database Migration Check

If `Bookstore.Data` uses Entity Framework, verify that any existing migrations are compatible with the version of EF Core now being used:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or incompatible, you may need to add a new migration or update the existing ones.