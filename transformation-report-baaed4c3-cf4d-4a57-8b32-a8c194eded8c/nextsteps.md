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

Verify that no warnings or errors appear related to missing or incompatible packages.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any compilation errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 5. Check Runtime-Specific Code

Review the codebase for any APIs that were available in .NET Framework but are not available or behave differently in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-only APIs such as those in `System.Drawing` without the appropriate compatibility package
- `ConfigurationManager` usage, which requires the `System.Configuration.ConfigurationManager` NuGet package

### 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework or another data access library, verify the connection strings in `appsettings.json` and confirm the application can connect to the database:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the application logs for any database connection errors on startup.

### 7. Test the Web Application Manually

Start the web application and navigate through the primary user-facing features to confirm that pages load correctly and core functionality works as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Open the URL shown in the console output (typically `http://localhost:5000` or `https://localhost:5001`) and verify the following:

- The application starts without exceptions
- Key pages render correctly
- Data is read from and written to the database as expected

### 8. Review Application Logs

After running the application, review the console output and any log files for runtime exceptions or deprecation warnings that may not have surfaced during the build step.