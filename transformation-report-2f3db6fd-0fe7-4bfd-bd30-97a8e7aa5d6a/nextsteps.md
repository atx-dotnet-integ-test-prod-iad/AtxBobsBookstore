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

Check the output for any warnings that, while non-blocking, may indicate areas that need attention, such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests that previously passed on the legacy framework should be investigated before proceeding.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in `appsettings.json`, as the configuration system differs between legacy ASP.NET and modern ASP.NET Core.
- **Domain logic**: Exercise the key domain operations through the UI or API endpoints to confirm `Bookstore.Domain` behaves as expected.
- **Static assets and routing**: Confirm that pages render correctly and that routing behaves as expected under ASP.NET Core conventions.

### 5. Review Configuration Files

Legacy projects often rely on `Web.config` or `App.config` for configuration. In cross-platform .NET, configuration is typically handled via `appsettings.json`. Confirm that:

- All connection strings have been migrated to `appsettings.json`.
- Any environment-specific settings are handled using `appsettings.{Environment}.json`.
- Any configuration previously handled by `Web.config` transforms has an equivalent in the new setup.

### 6. Check Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.

### 7. Review Removed Windows-Specific Dependencies

Cross-platform .NET does not support certain Windows-specific APIs. Search the codebase for any usage of APIs that may have been silently retained but will fail at runtime on non-Windows platforms, such as:

- `System.Web` types
- Windows Registry access
- COM interop

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all expected files, including static assets and configuration files, are present before deploying to the target environment.