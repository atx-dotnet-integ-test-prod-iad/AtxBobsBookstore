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

Review the output for any warnings related to package compatibility or version conflicts.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that the output reports zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failing tests, as they may indicate behavioral differences introduced by the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at a minimum:

- Application startup and landing page load
- Database connectivity through `Bookstore.Data` (check connection strings in `appsettings.json`)
- Core domain logic exposed through `Bookstore.Domain`
- Any pages or endpoints that interact with data reads and writes

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm that:

- Connection strings have been moved to `appsettings.json` or environment variables
- Any `Web.config` transforms or `app.config` entries have been accounted for in the new configuration system
- Environment-specific settings (e.g., `appsettings.Development.json`) are in place

### 6. Check Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid interoperability issues.

### 7. Review Data Layer

In `Bookstore.Data`, verify the following:

- The Entity Framework (or other ORM) package version is compatible with the target framework
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply pending migrations to a test database before deploying to production:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets, configuration files, and binaries are present before deploying to the target environment.