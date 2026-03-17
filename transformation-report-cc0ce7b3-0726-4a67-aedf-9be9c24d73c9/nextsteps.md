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

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the framework migration.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Specifically, confirm the following areas work as expected:

- **Data access**: Verify that `Bookstore.Data` connects to the database correctly. Check connection strings in `appsettings.json`, as these may have been previously stored in `Web.config` and may not have been fully migrated.
- **Domain logic**: Exercise key business logic paths to confirm `Bookstore.Domain` behaves as expected.
- **Web layer**: Navigate through the application's pages or endpoints to confirm routing, model binding, and rendering function correctly.

### 5. Review Configuration Files

Legacy .NET Framework projects relied on `Web.config` and `App.config` for configuration. Confirm that all relevant settings have been moved to `appsettings.json` or environment-specific variants such as `appsettings.Production.json`. Pay particular attention to:

- Database connection strings
- Application-specific settings
- Authentication or authorization configuration

### 6. Check for Platform-Specific Code

Since this migration targets cross-platform .NET, review the codebase for any APIs or libraries that are Windows-specific and may not function correctly on Linux or macOS. Common areas to check include:

- Use of the Windows Registry
- Windows-specific file path assumptions
- COM interop or P/Invoke calls
- Libraries that have not been updated for cross-platform support

### 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting a consistent and currently supported version of .NET.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce deployment artifacts:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all expected files are present, including static assets, configuration files, and the compiled assemblies.

### 3. Configure the Production Environment

Before deploying, ensure the production environment has the correct .NET runtime installed. Confirm that environment-specific configuration values, particularly connection strings and secrets, are set through environment variables or a secrets management solution rather than being hardcoded in configuration files.