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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they indicate regressions introduced during the migration or pre-existing issues.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correct and accessible from the new runtime environment.
- Any Entity Framework Core migrations are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application to verify it runs correctly end to end:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm expected behavior.

### 7. Check for Windows-Specific API Usage

Even without build errors, some APIs may compile successfully but fail at runtime on non-Windows platforms. Search the codebase for the following common problem areas:

- `Microsoft.Win32` namespace usage
- `Registry` access
- `System.Drawing` (GDI+) without the `System.Drawing.Common` compatibility package
- Windows-specific file path separators (use `Path.Combine` and `Path.DirectorySeparatorChar` instead)

### 8. Review Removed or Changed APIs

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any APIs that were available in .NET Framework but have changed behavior in modern .NET.

### 9. Validate Configuration System

.NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm that:

- Configuration has been moved to `appsettings.json`.
- `ConfigurationManager` usages have been replaced with `IConfiguration` from `Microsoft.Extensions.Configuration`.
- Environment-specific overrides (e.g., `appsettings.Production.json`) are in place where needed.

### 10. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy to the target hosting environment (e.g., IIS, Linux server with Kestrel, or Azure App Service). Ensure the target environment has the correct .NET runtime version installed.