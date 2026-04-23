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

## Validation Steps

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build context:

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

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime.

### 5. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and exercise the primary workflows, particularly any that involve database access through `Bookstore.Data` or domain logic in `Bookstore.Domain`.

### 6. Review Removed Windows-Specific APIs

Search the codebase for any APIs that may have been silently removed or stubbed out during transformation. Common areas to check include:

- `System.Web` references (not available in cross-platform .NET)
- `HttpContext` usage patterns that differ from ASP.NET Core
- Windows Registry or file path assumptions using backslashes

```bash
grep -r "System.Web" app/
```

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework or another ORM, confirm that:

- The connection string in `appsettings.json` is correctly configured for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Check for Remaining Platform-Specific Dependencies

Run the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tooling to surface any remaining platform-specific API usage that may not produce build errors but could cause runtime failures on non-Windows systems.

```bash
dotnet tool install -g dotnet-apicompat
```

Review the report and address any flagged APIs accordingly.