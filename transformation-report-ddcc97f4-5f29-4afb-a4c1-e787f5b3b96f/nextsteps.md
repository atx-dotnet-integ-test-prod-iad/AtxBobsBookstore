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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by migration-related changes or pre-existing issues.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup completes without exceptions
- Database connectivity works as expected through `Bookstore.Data`
- Domain logic in `Bookstore.Domain` behaves correctly end-to-end
- All primary routes and pages in `Bookstore.Web` load and respond correctly

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Review the code for any use of APIs that existed in .NET Framework but have changed or been removed in modern .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` and related types, which have moved to `Microsoft.AspNetCore.Http`
- Any Windows-specific APIs that may compile but fail at runtime on non-Windows platforms
- Entity Framework usage, confirming the project has migrated from EF6 to EF Core if applicable

### 7. Review Configuration Files

Confirm that legacy configuration files such as `Web.config` or `App.config` have been replaced or supplemented by `appsettings.json`. Verify that connection strings, application settings, and environment-specific values are correctly defined and loaded at runtime.

### 8. Test on Target Platform

If the goal of the migration includes running on Linux or macOS, run and test the application on the intended target operating system to surface any platform-specific issues that would not appear on Windows.