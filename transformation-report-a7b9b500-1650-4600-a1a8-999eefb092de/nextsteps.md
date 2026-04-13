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

Review the test results and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually test the following areas at a minimum:

- Application startup and home page loading
- Database connectivity through `Bookstore.Data` (check connection strings in `appsettings.json` for any environment-specific values that may need updating)
- Core domain logic exposed through `Bookstore.Domain`
- Any data read/write operations such as browsing, adding, or updating book records

### 5. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm the following:

- Connection strings are valid and point to the correct database instances
- Any legacy `web.config` or `app.config` values have been properly migrated to the new configuration system
- Authentication or authorization settings, if present, are correctly configured for ASP.NET Core

### 6. Check for Removed or Changed APIs

Review the codebase for usage of any APIs that were available in .NET Framework but behave differently or have been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references (these should no longer be present)
- Windows-specific APIs such as the registry, certain cryptography providers, or WCF server-side components
- Any third-party libraries that may still target .NET Framework only

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to assist with this review.

### 7. Validate the Data Layer

Confirm that any Entity Framework or other ORM configuration has been correctly migrated:

- If using Entity Framework Core, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.