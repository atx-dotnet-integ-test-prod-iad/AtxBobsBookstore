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

Check the output for any warnings that, while non-blocking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new .NET runtime.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- The connection string in your configuration file (`appsettings.json` or equivalent) is correct for your target environment.
- Any Entity Framework migrations are up to date. Run the following if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the target framework version.

### 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and exercise key features such as browsing, searching, and any data entry workflows.
- Check the console output and application logs for runtime exceptions or warnings.

### 7. Check for Windows-Specific APIs

Even without build errors, certain APIs that were available in .NET Framework may have changed behavior or limited support in cross-platform .NET. Review the code in each project for usage of:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to surface any remaining compatibility concerns.

### 8. Review Configuration System

.NET cross-platform projects use `appsettings.json` rather than `Web.config` or `App.config` for most configuration. Confirm that:

- All necessary configuration values have been migrated to `appsettings.json`.
- Any remaining `.config` files are intentional and still being read correctly.

### 9. Validate Logging

Confirm that logging is configured correctly using `Microsoft.Extensions.Logging` or a compatible provider. Check that log output appears as expected during local execution.