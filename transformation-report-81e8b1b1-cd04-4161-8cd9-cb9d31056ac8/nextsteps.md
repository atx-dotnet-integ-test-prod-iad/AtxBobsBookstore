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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the build output and confirm that all three projects report a successful build with zero errors and zero warnings, or investigate any warnings that may indicate deprecated APIs or compatibility concerns.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless that is intentional.

### 4. Check for Windows-Specific Dependencies

Inspect each project's NuGet package references and code for any APIs or packages that are Windows-only. Common areas to check include:

- `System.Drawing.Common` — has platform restrictions on non-Windows systems
- `Microsoft.Win32` namespaces
- Any COM interop or P/Invoke calls
- Registry access

Run the .NET Compatibility Analyzer if not already enabled by adding the following to each `.csproj`:

```xml
<EnableNETAnalyzers>true</EnableNETAnalyzers>
<AnalysisMode>All</AnalysisMode>
```

### 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no unit tests exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding.

### 6. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any database connection strings and Entity Framework configurations are valid for the new environment. If Entity Framework Core is being used, verify that pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If the project was migrated from Entity Framework 6 to Entity Framework Core, review the following:

- `DbContext` configuration
- Navigation property behavior changes
- Lazy loading configuration, which requires explicit setup in EF Core

### 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior. Review the console output and application logs for any runtime exceptions.

### 8. Test on Target Platform

If the goal is cross-platform execution, run the application on the target operating system (Linux or macOS) to surface any platform-specific runtime issues that would not appear during a Windows build.

### 9. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and deployable:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present.