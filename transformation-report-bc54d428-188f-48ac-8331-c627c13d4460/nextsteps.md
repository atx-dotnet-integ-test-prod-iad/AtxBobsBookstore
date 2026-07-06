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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- The connection strings in your configuration files (e.g., `appsettings.json`) are correct and accessible from the new runtime environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If you were previously using Entity Framework 6, confirm that the migration to EF Core was handled correctly, as there are API differences between the two.

### 5. Check Runtime Behavior of Bookstore.Web

Launch the web application locally and verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Specifically check:

- All routes resolve correctly.
- Authentication and authorization behave as expected.
- Any file system paths used in the application are written using `Path.Combine` or equivalent cross-platform APIs, rather than hardcoded backslashes.
- Static files are served correctly.

### 6. Review Configuration Files

Ensure that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or equivalent .NET configuration sources. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

### 7. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or dependencies that may not function correctly on Linux or macOS if cross-platform support is a requirement. Common areas to check include:

- Registry access
- Windows-specific authentication (e.g., NTLM/Windows Authentication)
- COM interop
- Hardcoded file path separators

### 8. Review Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file and verifying the `<TargetFramework>` element is set consistently across the solution, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```