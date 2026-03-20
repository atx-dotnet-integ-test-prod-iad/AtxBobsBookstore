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

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that were not fully modernized.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test output carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between the legacy framework and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- The connection strings in your configuration files (e.g., `appsettings.json`) are correct and updated from any legacy `Web.config` or `App.config` formats.
- Entity Framework migrations (if applicable) are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If you were previously using `System.Data` or another legacy data access mechanism, verify that the equivalent cross-platform APIs are functioning as expected against your target database.

### 5. Review Configuration Files

Legacy .NET Framework projects rely on `Web.config` and `App.config`. Cross-platform .NET uses `appsettings.json` and environment variables. Confirm that:

- All configuration values (connection strings, app settings, etc.) have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Any environment-specific configuration is correctly structured.
- The `Bookstore.Web` project is reading configuration through `IConfiguration` rather than `ConfigurationManager`.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate through the application in a browser.
- Test key user-facing features such as browsing, searching, and any data submission forms.
- Check the console output and application logs for runtime exceptions or warnings.

### 7. Review Middleware and HTTP Pipeline

If `Bookstore.Web` was previously an ASP.NET MVC or Web Forms project, confirm that the middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured, including:

- Authentication and authorization middleware.
- Static file serving.
- Routing configuration.
- Any custom HTTP modules or handlers that may have needed to be converted to middleware.

### 8. Inspect Target Framework Monikers

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid inter-project compatibility issues.