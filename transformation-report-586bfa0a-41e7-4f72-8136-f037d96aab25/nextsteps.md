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

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Run a full solution build to confirm the absence of errors:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is intact:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests that may indicate regressions introduced during the transformation.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connectivity functions correctly (check connection strings in your configuration files such as `appsettings.json`).
- Core application features such as browsing, searching, and managing books work as expected.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the traditional sense. Confirm the following:

- Connection strings and application settings have been moved to `appsettings.json` or environment variables.
- Any environment-specific settings are handled via `appsettings.Development.json` or `appsettings.Production.json`.
- Authentication or authorization configurations have been updated to use ASP.NET Core middleware.

### 6. Review Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the following:

- Entity Framework Core (or whichever ORM is in use) is correctly configured with the appropriate provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are present and up to date. If needed, run:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Check Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues.

### 8. Publish the Application

Once all validation steps pass, publish the application to confirm the output is complete and correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.