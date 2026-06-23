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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure all three projects are targeting a consistent framework version.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and address them before proceeding.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Production.json` are valid and point to the correct database.
- Any Entity Framework Core migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add <MigrationName> --project Bookstore.Data --startup-project Bookstore.Web
```

Then apply the migration to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

### 7. Check for Platform-Specific APIs

Search the codebase for any APIs that were available in .NET Framework but may behave differently or require alternative implementations in cross-platform .NET. Common areas to check include:

- `System.Web` references (should have been removed or replaced)
- Windows Registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `ConfigurationManager` usage (should be replaced with `Microsoft.Extensions.Configuration`)

### 8. Review Application Configuration

Confirm that configuration previously handled by `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Verify that environment-specific configuration files (e.g., `appsettings.Development.json`) are present and correctly structured.