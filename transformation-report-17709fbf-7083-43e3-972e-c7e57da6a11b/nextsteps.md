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

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in your configuration files (`appsettings.json`) to ensure they are valid for your target environment.
- **Domain logic**: Confirm that business rules in `Bookstore.Domain` behave as expected.
- **Web layer**: Navigate through the application pages and confirm that routing, model binding, and rendering work correctly.

### 5. Review Configuration Files

Check that `appsettings.json` (and any environment-specific variants such as `appsettings.Production.json`) contain all settings that were previously held in `Web.config` or `App.config`. Common items to verify include:

- Database connection strings
- Application-specific settings
- Logging configuration

### 6. Check for Platform-Specific Dependencies

Review the project references and NuGet packages for any libraries that may have platform-specific behavior. Pay particular attention to:

- Any packages that were previously targeting `.NET Framework` only
- Use of `System.Web` APIs, which are not available in cross-platform .NET
- Windows-specific APIs that may not function on Linux or macOS if cross-platform deployment is intended

### 7. Deployment

Once local validation is complete, publish the application using the following command, targeting your intended runtime:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server and ensure the correct .NET runtime version is installed on that server. You can verify the required runtime version in the `<TargetFramework>` element of `Bookstore.Web.csproj`.