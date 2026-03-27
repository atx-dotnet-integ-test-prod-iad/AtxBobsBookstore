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

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database as expected. If Entity Framework is in use, verify that migrations apply correctly using `dotnet ef database update`.
- **Domain logic**: Exercise the core domain operations through the UI or API endpoints to confirm expected behavior.
- **Static assets and routing**: Verify that pages render correctly and that routing behaves as it did in the legacy project.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 6. Check for Removed or Changed APIs

Review the code for any usage of APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to inspect include:

- `System.Web` references, which are not available in cross-platform .NET
- `ConfigurationManager`, which requires the `System.Configuration.ConfigurationManager` NuGet package
- Windows-specific APIs that may not behave correctly on non-Windows platforms

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformCompat.Analyzer` NuGet package to surface any remaining compatibility concerns.

### 7. Review Configuration Files

Confirm that `appsettings.json` contains all necessary configuration values that were previously held in `Web.config` or `App.config`. Verify that connection strings, application settings, and environment-specific values have been migrated correctly.