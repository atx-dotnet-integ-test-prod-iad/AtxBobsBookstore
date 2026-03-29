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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings, particularly around deprecated APIs or target framework compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually exercise key workflows such as browsing, searching, and any data-driven pages:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Pay particular attention to:
- Database connectivity and Entity Framework migrations (if applicable)
- Any features that previously relied on Windows-specific APIs (e.g., `System.Web`, MSMQ, COM interop)
- Authentication and session handling, which can behave differently under ASP.NET Core

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Review the code for any use of APIs that are absent or behave differently in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available outside of ASP.NET Core equivalents
- `ConfigurationManager`, which should be replaced with `Microsoft.Extensions.Configuration`
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can assist in identifying remaining compatibility concerns.

### 7. Validate Data Layer

If the project uses Entity Framework, confirm that any pending migrations are applied and the schema is consistent:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Test all data access paths, including reads, writes, and any stored procedure calls.

### 8. Test on Target Operating Systems

If cross-platform support is a goal, run the application on each intended operating system (Windows, Linux, macOS) to surface any platform-specific issues that may not appear at compile time.