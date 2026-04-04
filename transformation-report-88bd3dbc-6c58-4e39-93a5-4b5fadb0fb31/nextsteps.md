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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that the build output reports zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. If the project previously used a Windows-specific connection string or SQL Server authentication method (such as Windows Authentication), you may need to update the connection string in `appsettings.json` to suit the target environment.
- **Domain logic**: Exercise the core domain functionality through the UI or API endpoints to confirm expected behavior.
- **Static assets and routing**: Verify that pages load correctly and that routing behaves as expected under the new framework.

### 5. Review Configuration Files

Cross-platform .NET applications rely on `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- All connection strings have been moved to `appsettings.json` or environment-specific variants such as `appsettings.Production.json`.
- Any configuration values previously stored in `Web.config` (such as app settings or custom configuration sections) are present and correctly structured in the new configuration system.
- Environment-specific settings are handled using the `IConfiguration` interface rather than `ConfigurationManager`.

### 6. Check for Windows-Specific API Usage

Even when a project builds without errors, it may still use APIs that are not supported on non-Windows platforms. Run the .NET compatibility analyzer if you intend to deploy to Linux or macOS:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

Review any `CA1416` platform compatibility warnings, which indicate calls to Windows-only APIs.

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

## Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment. Ensure the target machine has the appropriate .NET runtime installed. You can verify the required runtime version from the `TargetFramework` value in the web project's `.csproj` file.