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

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test output for any failures that may have been introduced during the migration. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

### 4. Verify Entity Framework Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework, confirm that your migrations are compatible with the new target framework. Run the following to check the current migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or inconsistent, you may need to add a new migration:

```bash
dotnet ef migrations add PostMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Then apply the migration to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify that core functionality such as browsing, searching, and any data-driven pages operate correctly.

### 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) to confirm the following:

- Connection strings are correct and point to the intended database.
- Any configuration keys that were previously in `Web.config` have been properly migrated to the new configuration system.
- Logging settings are appropriate for your environment.

### 7. Check for Runtime Compatibility Issues

Even with a clean build, certain APIs behave differently on cross-platform .NET compared to .NET Framework. Specifically, review the following areas:

- **File system paths**: Ensure no hardcoded Windows-style paths (e.g., backslashes) exist in the codebase. Use `Path.Combine` where applicable.
- **Registry access**: Any use of the Windows Registry will not function on non-Windows platforms.
- **Windows-specific libraries**: Verify that no remaining dependencies rely on Windows-only APIs, particularly within `Bookstore.Data` or `Bookstore.Web`.

### 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.