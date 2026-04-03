# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects (`Bookstore.Data`, `Bookstore.Web`, or `Bookstore.Domain`). The solution compiled cleanly across all projects.

## Validation

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the clean state holds outside of the transformation environment:

```bash
dotnet build --configuration Release
```

Verify that the output reports zero errors and review any warnings that may indicate compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Pay attention to any tests that may be exercising platform-specific behavior that could differ on non-Windows environments.

### 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, confirm that any database migrations and the data context are functioning correctly:

```bash
dotnet ef dbcontext info --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations exist, verify they are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the database schema needs to be applied:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and confirm it runs as expected:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry features, to confirm end-to-end functionality.

### 6. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) to ensure:

- Connection strings are correct for the target environment.
- Any configuration keys that were previously stored in `Web.config` have been properly migrated to the new configuration system.
- Secrets are not stored directly in configuration files and are instead managed via environment variables or a secrets manager.

### 7. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` value is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects so there are no implicit framework mismatches at runtime.

### 8. Cross-Platform Smoke Test

If cross-platform support is a goal, run the application on a non-Windows environment (Linux or macOS) to surface any remaining platform-specific dependencies such as Windows registry access, `System.Drawing.Common`, or Windows-only file path assumptions.