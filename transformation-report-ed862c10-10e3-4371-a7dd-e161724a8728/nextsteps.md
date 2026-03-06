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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or platform-specific code that could cause runtime issues even if the build succeeds.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- The connection strings in your configuration files (e.g., `appsettings.json`) are correct for your target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add <MigrationName> --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary workflows to confirm that pages load correctly and data operations function as expected.

### 6. Check for Platform-Specific Code

Even without build errors, review the codebase for any APIs or patterns that may not behave identically on cross-platform .NET compared to .NET Framework. Common areas to inspect include:

- File path handling (use `Path.Combine` rather than hardcoded separators)
- Registry access (`Microsoft.Win32.Registry`), which is Windows-only
- `System.Drawing` usage, which may require the `System.Drawing.Common` package and has platform limitations on non-Windows systems
- Any use of `HttpContext.Current`, which is not available in ASP.NET Core

### 7. Review Configuration and Middleware

In `Bookstore.Web`, confirm that:

- `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`
- Authentication, authorization, and any custom middleware are correctly configured in `Program.cs` or `Startup.cs`
- Static file serving and routing are functioning as intended

### 8. Validate Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across projects to avoid unexpected compatibility issues between assemblies.