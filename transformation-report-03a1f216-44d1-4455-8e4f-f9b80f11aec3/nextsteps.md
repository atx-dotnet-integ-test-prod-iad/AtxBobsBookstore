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

Verify that no warnings or errors appear during restoration, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any compile-time errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while non-blocking, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test
```

Review test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm that:

- The connection strings in your configuration files (e.g., `appsettings.json`) are correct and accessible from the new runtime environment.
- Any Entity Framework migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If you were previously using `App.config` for connection strings, confirm these have been migrated to `appsettings.json` and are being read correctly.

### 5. Verify Runtime Behavior of Bookstore.Web

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following:

- Application starts without runtime exceptions.
- All routes and pages load as expected.
- Any authentication or session handling behaves correctly, as these areas can differ between .NET Framework and cross-platform .NET.
- Static files (CSS, JS, images) are served correctly.

### 6. Review Target Framework

Open each `.csproj` file and confirm that the `TargetFramework` is set to an appropriate and consistent version across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing target frameworks across projects in the same solution can cause subtle runtime issues.

### 7. Check for Removed or Changed APIs

Review any usages of APIs that were removed or significantly changed in cross-platform .NET, including:

- `System.Web` namespace references, which are not available outside of ASP.NET on .NET Framework.
- `HttpContext` usage patterns that may differ in ASP.NET Core.
- Any Windows-specific APIs (e.g., registry access, WCF server-side) that do not exist in cross-platform .NET.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining compatibility concerns.

### 8. Review Configuration System

Confirm that configuration previously handled by `Web.config` or `App.config` has been fully migrated to the ASP.NET Core configuration system using `appsettings.json` and the `IConfiguration` interface.

### 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Inspect the output directory to ensure all required files, including views, static assets, and configuration files, are present.