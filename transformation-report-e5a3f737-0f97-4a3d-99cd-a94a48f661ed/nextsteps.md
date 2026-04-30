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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types or obsolete APIs, as these can indicate areas that may need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test output carefully. Any failing tests should be investigated before proceeding.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup completes without exceptions
- Database connectivity works as expected (check `Bookstore.Data` operations)
- Core domain logic in `Bookstore.Domain` behaves correctly through the UI or API endpoints
- Any configuration values (connection strings, app settings) are correctly loaded from `appsettings.json` or environment variables, replacing any legacy `Web.config` or `App.config` values that may have existed

### 5. Review Configuration Files

Confirm that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`. Specifically check:

- Database connection strings
- Application-specific settings
- Any environment-specific overrides

### 6. Check Target Framework

Open each `.csproj` file and verify the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported framework version.

### 7. Review Entity Framework Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework, verify that existing migrations are compatible with the new runtime. Run the following to check the current migration state against the database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations fail or are incompatible, consider generating a new baseline migration.

### 8. Static File and Middleware Verification

For `Bookstore.Web`, confirm that middleware previously configured via `Global.asax` or `Startup.cs` (classic) has been correctly moved to the `Program.cs` or `Startup.cs` pattern used in modern .NET. Verify:

- Static files are served correctly
- Authentication and authorization middleware is in place if applicable
- Routing behaves as expected