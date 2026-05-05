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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic unit tests for the core domain logic in `Bookstore.Domain` before proceeding.

### 5. Verify Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- Connection strings in `appsettings.json` are correct for the target environment.
- Any Entity Framework Core migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, data retrieval) to confirm end-to-end functionality.

### 7. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that were acceptable in .NET Framework but may behave differently on cross-platform .NET. Common areas to review include:

- File path handling (use `Path.Combine` rather than hardcoded separators).
- Registry access (`Microsoft.Win32.Registry`), which is Windows-only.
- Any use of `System.Web` namespaces, which are not available in cross-platform .NET.

### 8. Review Deprecated or Removed APIs

Run the .NET Upgrade Analyzer or review build warnings to identify any API usage that is obsolete in the target framework version. Address these before considering the migration complete.