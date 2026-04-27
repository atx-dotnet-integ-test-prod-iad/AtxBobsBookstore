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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Review the NuGet packages and any `using` directives across all three projects for APIs that are Windows-only. Common areas to check include:

- `System.Web` references, which are not available on cross-platform .NET
- Any use of the Windows Registry (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side components
- Any P/Invoke calls targeting Windows-specific native libraries

### 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves correctly under the new framework:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether failures are caused by framework differences or pre-existing issues.

### 6. Validate the Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target framework version.
- Connection strings in configuration files (`appsettings.json`) are correct and accessible in the new runtime environment.
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update
```

### 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs without runtime exceptions:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application's primary workflows to confirm pages load correctly and data operations function as expected.

### 8. Review Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all settings that were previously held in `Web.config` or `App.config`. Key areas include:

- Connection strings
- Logging configuration
- Application-specific settings

### 9. Deployment

Once local validation is complete, publish the application using the following command, targeting the appropriate runtime identifier for your server environment:

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Copy the contents of the publish output directory to your target server and configure your web server (e.g., Nginx or IIS on Windows) to point to the published application.