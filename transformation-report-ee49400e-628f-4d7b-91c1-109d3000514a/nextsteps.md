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

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Specifically verify the following areas, as they are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. Check your connection strings in `appsettings.json` and ensure the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the target .NET version.
- **Entity Framework migrations**: If using EF Core, run `dotnet ef database update` to confirm migrations apply cleanly.
- **Static files and routing**: Confirm that pages, views, and static assets load correctly in the browser.
- **Authentication and authorization**: If the application uses identity or cookie-based auth, verify that login flows and protected routes behave as expected.

### 5. Review Configuration Files

Compare `appsettings.json` and any environment-specific configuration files against the original `Web.config` or `App.config` to ensure all settings were carried over, including:

- Connection strings
- Application settings
- Logging configuration

### 6. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but are not supported in cross-platform .NET. Common examples include:

- `System.Web` references
- Windows Registry access
- `AppDomain` usage beyond what is supported
- `BinaryFormatter` (deprecated and disabled by default)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining compatibility concerns.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, assets, and dependencies are present before deploying to your target environment.