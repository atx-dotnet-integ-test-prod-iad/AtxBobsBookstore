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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated as part of the migration.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without errors or warnings that could indicate runtime issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is intact:

```bash
dotnet test
```

Review test results carefully. Any failing tests that previously passed may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that your data access layer is functioning correctly:

- Verify that your connection strings in `appsettings.json` are correct for your target environment.
- If Entity Framework Core is in use, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used Entity Framework 6, confirm it has been migrated to Entity Framework Core, as EF6 does not fully support cross-platform .NET.

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows.
- Check the console output for any runtime exceptions or warnings.
- Verify that static files, routing, and middleware are functioning correctly.

### 6. Review Configuration

Cross-platform .NET handles configuration differently than .NET Framework. Confirm the following:

- `Web.config` transforms are no longer in use; settings have been moved to `appsettings.json`.
- Any environment-specific configuration is handled via `appsettings.{Environment}.json` or environment variables.
- The `ASPNETCORE_ENVIRONMENT` variable is set appropriately for each environment.

### 7. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that may have been available in .NET Framework but behave differently or are unavailable in cross-platform .NET:

- `System.Web` references should have been removed or replaced.
- Windows-specific APIs such as the registry, COM interop, or WCF client usage should be reviewed if the application is intended to run on non-Windows platforms.

### 8. Deployment

Once local validation is complete, deploy the application to your target environment:

```bash
dotnet publish --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server and configure your web server (IIS, Kestrel, or a reverse proxy such as Nginx) to host the application according to the [official ASP.NET Core hosting documentation](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/).