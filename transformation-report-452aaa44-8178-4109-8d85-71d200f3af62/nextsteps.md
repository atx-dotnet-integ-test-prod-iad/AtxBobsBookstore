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

Perform a full solution build to confirm the error-free state holds under a clean build:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns with the new target framework.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Access Layer

Since the solution includes a `Bookstore.Data` project, confirm that:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider matching your database).
- Any migrations are present and up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Review Configuration Files

- Confirm that `appsettings.json` contains the correct connection strings and application settings, replacing any values that were previously in `Web.config` or `App.config`.
- Verify that environment-specific settings (e.g., `appsettings.Development.json`) are present and correctly configured.

### 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test the primary workflows such as browsing, searching, and any data entry forms.

### 7. Check for Runtime Compatibility Issues

Even with a clean build, certain APIs behave differently on cross-platform .NET. Pay attention to:

- **File path handling**: Ensure no hardcoded Windows-style paths (`\`) exist; use `Path.Combine` instead.
- **Configuration binding**: Confirm that any strongly-typed configuration classes bind correctly from `appsettings.json`.
- **Authentication and session handling**: If the application uses forms authentication or session state, verify these have been correctly migrated to their ASP.NET Core equivalents.
- **HTTP modules and handlers**: These do not exist in ASP.NET Core. Confirm they have been replaced with middleware.

### 8. Review Deprecated or Removed APIs

Run the .NET Upgrade Analyzer or inspect build warnings to identify any API usage that is present but marked as obsolete in the new framework version:

```bash
dotnet build 2>&1 | grep -i warning
```

Address any obsolete API warnings to reduce future technical debt.