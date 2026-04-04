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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Platform-Specific APIs

Review the code in each project for any remaining usage of Windows-specific APIs, such as:

- `System.Web` namespaces
- Windows Registry access
- `HttpContext` patterns specific to ASP.NET (non-Core)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining compatibility concerns.

### 6. Run the Application Locally

Start the `Bookstore.Web` project and verify that the application runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the primary user-facing workflows, including any data access operations that involve `Bookstore.Data` and domain logic from `Bookstore.Domain`.

### 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core or another data access library, verify that:

- The connection string in `appsettings.json` is correctly configured for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Logging and Configuration

Confirm that the application configuration system has been fully migrated from any legacy `Web.config` or `App.config` patterns to the `appsettings.json` and `IConfiguration` model standard in cross-platform .NET.