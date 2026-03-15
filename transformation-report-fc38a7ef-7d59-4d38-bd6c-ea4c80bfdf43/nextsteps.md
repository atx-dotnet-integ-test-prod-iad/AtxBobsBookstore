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

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` is likely responsible for database access, confirm the following:

- The correct database provider NuGet package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`, etc.).
- Connection strings in `appsettings.json` are correctly configured for your target environment.
- Any Entity Framework migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry features, to confirm end-to-end functionality.

### 6. Review Configuration Files

Check that the following have been properly migrated from any legacy `Web.config` or `App.config` files:

- Connection strings are present in `appsettings.json`.
- Any application settings previously stored under `<appSettings>` have been moved to `appsettings.json` and accessed via `IConfiguration`.
- Any HTTP handlers, modules, or custom error pages previously configured in `Web.config` have been replaced with the appropriate ASP.NET Core middleware in `Program.cs` or `Startup.cs`.

### 7. Review Replaced or Removed APIs

Cross-platform .NET does not support certain Windows-specific APIs. Audit the codebase for any remaining usage of:

- `System.Web` namespaces (these are not available in ASP.NET Core).
- `HttpContext.Current` (replace with injected `IHttpContextAccessor`).
- Windows Registry access or Windows-only I/O paths.
- `ConfigurationManager` (replace with `IConfiguration`).

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining incompatible API calls:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze Bookstore.Web
```

### 8. Check Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file for the `<TargetFramework>` element, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-framework compatibility issues.