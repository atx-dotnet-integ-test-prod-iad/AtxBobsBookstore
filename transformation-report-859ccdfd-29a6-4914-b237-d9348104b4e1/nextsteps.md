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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-breaking, may indicate compatibility concerns worth addressing.

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

Review any failing tests to determine whether failures are caused by the migration or were pre-existing.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- Connection strings in `appsettings.json` are correct and accessible from the new runtime environment.
- Any Entity Framework Core migrations are up to date. Run the following if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the target framework version.

### 6. Run the Web Application Locally

Start the web application to perform a basic smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core pages and functionality load without runtime errors. Check the console output and application logs for any exceptions.

### 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Review the code in all three projects for usage of the following common problem areas:

- `System.Web` namespace references (not available in cross-platform .NET)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- Windows-specific APIs such as the registry, WCF server-side components, or `System.Drawing` without the appropriate compatibility package

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling if further analysis is needed.

### 8. Test on Target Operating Systems

If cross-platform support is a goal, run and test the application on each intended operating system (e.g., Windows, Linux, macOS) to surface any platform-specific runtime issues that do not appear at build time.