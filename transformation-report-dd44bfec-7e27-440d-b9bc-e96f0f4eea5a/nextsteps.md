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

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project is still referencing `net48` or any other legacy .NET Framework moniker.

### 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that existed in .NET Framework but have changed behavior or limited support in modern .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` and related types, which should now come from `Microsoft.AspNetCore.Http`
- Windows-only APIs such as the registry, WMI, or COM interop, which will not function on non-Windows platforms

### 5. Run Unit Tests

If the solution contains test projects, execute them to verify runtime behavior:

```bash
dotnet test --configuration Release
```

Examine any failing tests to determine whether they reflect a behavioral difference introduced by the migration.

### 6. Run the Application Locally

Start the web application and exercise its primary functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following areas manually:

- Application startup without exceptions
- Database connectivity through `Bookstore.Data`
- Domain logic correctness through `Bookstore.Domain`
- All major routes and pages in `Bookstore.Web` load and function as expected

### 7. Verify Database Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date and apply cleanly against the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project was previously using Entity Framework 6, confirm that it has been migrated to Entity Framework Core, as EF6 does not support cross-platform .NET.

### 8. Review Configuration Files

Confirm that `appsettings.json` contains all configuration values that were previously held in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

The `Web.config` and `App.config` files are not used by ASP.NET Core applications at runtime.

### 9. Validate Platform Compatibility

If the application is intended to run on Linux or macOS, test it on the target platform to surface any remaining platform-specific issues, such as case-sensitive file paths or OS-specific dependencies.