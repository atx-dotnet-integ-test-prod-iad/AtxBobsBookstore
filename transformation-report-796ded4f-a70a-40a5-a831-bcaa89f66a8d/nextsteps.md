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

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that were not fully modernized.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing behavior has been preserved after the transformation:

```bash
dotnet test --configuration Release
```

Review test output carefully. Any failing tests should be investigated to determine whether they reflect a regression introduced during migration or a pre-existing issue.

### 4. Verify Runtime Behavior

Start the web application locally and navigate through its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in `appsettings.json` or `appsettings.Development.json`, as these may have been previously stored in `Web.config` and need to be migrated to the new configuration format.
- **Domain logic**: Exercise the primary domain operations to confirm `Bookstore.Domain` behaves as expected.
- **Web layer**: Navigate through the application pages or API endpoints to confirm routing, model binding, and rendering work correctly.

### 5. Review Configuration Files

Legacy .NET Framework projects often rely on `Web.config` or `App.config` for configuration. Confirm that all relevant settings have been moved to `appsettings.json`:

- Connection strings
- Application settings (e.g., API keys, feature flags)
- Logging configuration

### 6. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` element is set to the intended modern .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid compatibility issues between assemblies.

### 7. Review Removed Windows-Specific Dependencies

Cross-platform migration may have removed or replaced Windows-specific APIs. Search the codebase for any remaining usages of:

- `System.Web` namespaces
- Windows registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

Replace any such usages with their cross-platform equivalents where found.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce a deployment-ready output:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all expected files are present, including static assets, configuration files, and dependent assemblies.

### 3. Test Against the Target Environment

Deploy the published output to the target environment (e.g., a staging server) and run a smoke test against it before promoting to production. Pay particular attention to environment-specific configuration values that differ from your local setup.