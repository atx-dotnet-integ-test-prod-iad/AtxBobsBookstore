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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting critical logic in `Bookstore.Domain` and `Bookstore.Data`.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core or other data access configuration is functioning correctly:

- Check that connection strings in `appsettings.json` are valid for the target environment.
- If using Entity Framework Core, run the following to verify migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a local development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

### 7. Review Windows-Specific APIs

Search the codebase for any APIs that may have been available in the legacy .NET Framework but have limited or no support in cross-platform .NET. Common areas to check include:

- `System.Web` references
- Windows Registry access
- `HttpContext` usage patterns specific to ASP.NET (non-Core)
- Any P/Invoke calls targeting Windows-only native libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this review if needed.

### 8. Test on Target Platform

If the goal is cross-platform deployment, run the application on the intended non-Windows operating system (Linux or macOS) to surface any remaining platform-specific issues that would not appear during Windows-based development.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then execute the published output on the target platform and verify runtime behavior.