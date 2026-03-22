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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs or platform compatibility, as these can surface behavioral issues at runtime even when the build succeeds.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that core logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, verify the following:

- The correct database provider NuGet package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider appropriate for your database).
- Connection strings in configuration files (`appsettings.json`) are valid and accessible from the target environment.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- Application startup completes without exceptions.
- Routing and page rendering work as expected.
- Any authentication or session handling behaves correctly.
- Static assets (CSS, JavaScript, images) are served properly.

### 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config` for most configuration. Confirm that:

- All necessary configuration values have been migrated to `appsettings.json` or `appsettings.{Environment}.json`.
- Any environment-specific settings (e.g., connection strings, API keys) are correctly set for each target environment.
- `Web.config` entries that handled things like HTTP modules, handlers, or custom errors have been replaced with the appropriate ASP.NET Core middleware in `Program.cs` or `Startup.cs`.

### 7. Check for Platform-Specific API Usage

Even with a clean build, some APIs behave differently or are unavailable on non-Windows platforms. Review the codebase for usage of:

- `System.Web` types (these are not available in cross-platform .NET).
- Windows Registry access.
- Windows-specific file path assumptions (e.g., backslashes).
- COM interop or P/Invoke calls targeting Windows-only libraries.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining compatibility concerns.

### 8. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy it to your target hosting environment (e.g., IIS, Azure App Service, or a Linux host with the ASP.NET Core runtime installed). Ensure the correct .NET runtime version is installed on the target server.