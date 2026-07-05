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

Check the output for any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` likely contains database access logic, confirm the following:

- The correct version of Entity Framework Core (or whichever ORM is in use) is referenced.
- Any database migrations are up to date. If using EF Core, run:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Connection strings in configuration files (e.g., `appsettings.json`) are correct for the target environment.

### 5. Review Configuration Files

Ensure that `appsettings.json` contains all settings that were previously in `Web.config` or `App.config`. Common items to check include:

- Database connection strings
- Logging configuration
- Application-specific settings

### 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and test the primary user-facing features, such as browsing, searching, and any data entry flows.

### 7. Check for Platform-Specific API Usage

Use the .NET Upgrade Assistant compatibility analyzer or review the code manually for any APIs that may behave differently on Linux or macOS if cross-platform deployment is intended. Pay particular attention to:

- File path handling (`Path.Combine` vs hardcoded separators)
- Registry access (not available on non-Windows platforms)
- Windows-specific authentication mechanisms

### 8. Review Warnings as Potential Issues

Even without build errors, compiler warnings can indicate areas that may cause runtime problems. Run the build with warnings treated as informational and review them:

```bash
dotnet build --configuration Release /p:TreatWarningsAsErrors=false
```

Address any warnings related to deprecated or platform-incompatible APIs before deploying.

## Deployment

Once validation steps above are completed without issues:

1. Publish the application using the appropriate runtime identifier for your target environment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

2. Verify the contents of the `./publish` directory contain all expected assemblies and static assets.
3. Deploy the contents of the publish output to your target hosting environment (IIS, Kestrel behind a reverse proxy, or similar).