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

Verify that no warnings or errors are reported during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they do not cause build failures.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new target framework.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas in particular:

- Database connectivity and data access through `Bookstore.Data`
- Domain logic correctness through `Bookstore.Domain`
- All major routes and pages in `Bookstore.Web` load without errors
- Any authentication or authorization flows function as expected

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version, for example `net8.0`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid compatibility issues between them.

### 6. Check for Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Review the following areas manually:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET
- `HttpContext` access patterns, which differ between ASP.NET and ASP.NET Core
- Configuration access, which has moved from `ConfigurationManager` to `IConfiguration`
- Any file path handling that may have assumed Windows-style separators

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to surface any remaining compatibility concerns.

### 7. Review Database Migrations

If `Bookstore.Data` uses Entity Framework, verify that all migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations against a test database before deploying to production:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Validate Configuration Files

Ensure that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`, including connection strings and application settings. Confirm that environment-specific overrides such as `appsettings.Development.json` are in place where needed.