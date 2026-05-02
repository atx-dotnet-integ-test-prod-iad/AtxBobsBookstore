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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear related to missing or incompatible packages.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any compile-time errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility issues, deprecated APIs, or missing references, even if the build succeeds.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Verify connection strings in your configuration files (e.g., `appsettings.json`) are correct for the target environment.
- **Domain logic**: Exercise the core domain functionality through the UI or API endpoints to confirm `Bookstore.Domain` behaves as expected.
- **Web layer**: Navigate through the application pages or endpoints to confirm routing, middleware, and rendering work as intended.

### 5. Review Configuration Files

Ensure that any configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Database connection strings
- Application-specific settings
- Authentication or authorization configuration

### 6. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 7. Review Removed Windows-Specific Dependencies

Check that no references to Windows-only APIs or libraries remain. If any `PlatformNotSupportedException` errors appear at runtime, identify the offending API and replace it with a cross-platform alternative.