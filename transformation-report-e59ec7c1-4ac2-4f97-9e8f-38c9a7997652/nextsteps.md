# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects in the solution:

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

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework), verify the following:

- Confirm the correct version of Entity Framework Core is referenced, as EF Core differs from EF6 in several areas.
- If migrations are used, run the following to ensure the migration state is valid:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Test all database operations (CRUD) against a local or development database to confirm queries execute as expected.

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following:

- Application starts without runtime exceptions.
- All routes and pages load correctly.
- Static assets (CSS, JavaScript, images) are served properly.
- Authentication and authorization flows work as expected, if applicable.
- Any configuration values in `appsettings.json` are correct and replace any legacy `Web.config` or `App.config` entries that may have been used previously.

### 6. Review Configuration Migration

Ensure that any settings previously stored in `Web.config` or `App.config` have been correctly moved to `appsettings.json` or environment-specific configuration files such as `appsettings.Development.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Any custom configuration sections

### 7. Check for Platform-Specific API Usage

Run the .NET Upgrade Analyzer or review the code manually for any remaining usage of Windows-specific APIs that may not be available on Linux or macOS if cross-platform support is required:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Review any `CA1416` platform compatibility warnings that appear in the output.

### 8. Test on Target Deployment Platform

If the application is intended to run on a non-Windows platform, run and test the application on that target operating system to surface any remaining platform-specific issues before deploying to a production environment.