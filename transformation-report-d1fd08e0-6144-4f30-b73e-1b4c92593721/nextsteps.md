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

Check the output for any warnings that, while non-blocking, may indicate deprecated APIs or framework-specific code paths that could cause runtime issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Access Layer

Since the solution includes a `Bookstore.Data` project, confirm that the data access layer is functioning correctly:

- Verify that the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- If the project uses migrations, run the following to confirm they are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser.
- Test key workflows such as browsing, searching, and any data entry forms.
- Check the console output and application logs for runtime exceptions or warnings.

### 6. Review Configuration Files

- Confirm that `appsettings.json` contains the correct connection strings and application settings, replacing any values that were previously stored in `Web.config` or `App.config`.
- Ensure environment-specific settings (e.g., `appsettings.Development.json`) are configured appropriately.

### 7. Check for Windows-Specific Dependencies

Even with a successful build, review the codebase for any APIs or libraries that are Windows-specific and may not behave correctly on Linux or macOS if cross-platform deployment is intended. Common areas to check include:

- Registry access
- Windows Authentication
- `System.Drawing` usage (consider migrating to `System.Drawing.Common` or an alternative such as `SkiaSharp`)

### 8. Review Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` to avoid cross-framework reference issues.