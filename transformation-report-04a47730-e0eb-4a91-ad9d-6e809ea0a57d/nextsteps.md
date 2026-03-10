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

Check the output for any warnings that, while non-breaking, may indicate areas that need attention, such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas which are commonly affected by cross-platform migrations:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations apply cleanly using `dotnet ef database update`.
- **File paths**: Ensure no hardcoded Windows-style paths (e.g., `C:\`) exist in configuration files or code, as these will not resolve correctly on Linux or macOS.
- **Configuration**: Confirm that `appsettings.json` or equivalent configuration files are present and loading correctly, replacing any legacy `Web.config` or `App.config` values that may not have been fully migrated.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or Windows Authentication, verify that the middleware is configured correctly for the new hosting model.
- **Static files and routing**: Confirm that static assets are served correctly and that all routes resolve as expected.

### 5. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the codebase for usage of the following, which are commonly removed or changed:

- `System.Web` namespace references (not available in .NET Core/.NET 5+)
- `HttpContext.Current`
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- Binary formatters (`BinaryFormatter` is disabled by default)
- Windows-specific APIs in `Bookstore.Domain` or `Bookstore.Data`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining compatibility concerns.

### 6. Check Target Framework

Confirm that all three projects are targeting the intended framework version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` to avoid cross-framework reference issues.

### 7. Review Publish Output

Before deploying, perform a publish dry run to confirm the output is complete:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required assemblies, configuration files, and static assets are present.