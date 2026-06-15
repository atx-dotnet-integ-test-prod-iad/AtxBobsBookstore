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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns worth addressing before deployment.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas which are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. Check your connection strings in `appsettings.json` and ensure they are not still referencing a `Web.config` or `App.config` source.
- **Entity Framework**: If Entity Framework is used, confirm that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Static files and routing**: Navigate through the web application to confirm that pages render correctly and routing behaves as expected.
- **Authentication and Authorization**: If the application uses authentication, test login and access-control flows explicitly, as these subsystems changed significantly between .NET Framework and cross-platform .NET.

### 5. Review Configuration

Confirm that configuration has been fully migrated away from `Web.config` to the `appsettings.json` pattern. Check for the following:

- Connection strings are present in `appsettings.json`.
- Any custom `appSettings` keys from the old `Web.config` have been moved to `appsettings.json` and are being read via `IConfiguration`.
- Environment-specific overrides are handled using `appsettings.{Environment}.json` files where appropriate.

### 6. Check for Platform-Specific API Usage

Even without build errors, certain APIs behave differently or are unsupported on non-Windows platforms. If you intend to run this application on Linux or macOS, review the code in all three projects for usage of:

- `System.Drawing` (GDI+)
- Windows Registry access
- COM interop
- Windows-specific file path assumptions (e.g., backslash separators)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining platform-specific concerns.

### 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.