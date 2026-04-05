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

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- Connection strings in `appsettings.json` or `appsettings.Production.json` are correctly configured for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output and confirm that the application loads and core functionality works correctly.

### 6. Review Configuration Files

Check the following files to ensure settings are appropriate for the target platform and environment:

- `appsettings.json` — General application settings.
- `appsettings.Development.json` — Development-specific overrides.
- `appsettings.Production.json` — Production-specific overrides, particularly connection strings and logging levels.

Ensure no legacy Windows-specific paths, registry references, or platform-specific APIs remain in the configuration or code.

### 7. Check for Platform-Specific API Usage

Even without build errors, there may be runtime issues caused by APIs that existed in .NET Framework but behave differently or are unavailable in cross-platform .NET. Review the codebase for usage of:

- `System.Web` namespaces (these are not available in cross-platform .NET).
- Windows-specific APIs such as the registry, Windows identity, or COM interop.
- Any third-party libraries that may not have cross-platform support.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling if a deeper compatibility audit is needed.

### 8. Review Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file and verifying the `<TargetFramework>` element, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If an older version such as `net6.0` is present and a newer LTS release is preferred, update accordingly and re-run the build and tests.