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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- Connection strings in `appsettings.json` or `appsettings.Production.json` are valid and point to the correct database.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the URL printed in the console output.
- Confirm that pages load correctly and that data is being retrieved from the database.
- Check the console and application logs for any runtime exceptions.

### 6. Review Configuration Files

- Confirm that `appsettings.json` contains all required configuration keys that were previously in `Web.config` or `App.config`.
- Verify that environment-specific settings (e.g., `appsettings.Development.json`, `appsettings.Production.json`) are in place and correct.
- Ensure that any static files, bundling, or middleware configurations previously handled by IIS or System.Web have been replaced with their ASP.NET Core equivalents.

### 7. Review Target Framework

Open each `.csproj` file and confirm that the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 8. Check for Removed or Replaced APIs

Review the codebase for any usage of APIs that were available in .NET Framework but behave differently or have been replaced in cross-platform .NET, including:

- `HttpContext` usage outside of controllers or middleware.
- `System.Web` references that may have been stubbed out during transformation.
- Any Windows-specific APIs such as the registry, WCF, or MSMQ, which may require alternative implementations.

### 9. Deploy to Target Environment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server and configure the hosting environment (e.g., IIS with the ASP.NET Core Module, or a reverse proxy such as Nginx) according to the standard ASP.NET Core hosting documentation.