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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may point to behavioral differences introduced during the migration.

### 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, confirm that the data layer is functioning correctly:

- Check that the database connection strings in your configuration files (e.g., `appsettings.json`) are correct for the target environment.
- If Entity Framework is used, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If needed, apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary user-facing features.
- Check the console output and application logs for any runtime exceptions or warnings.

### 6. Review Configuration Files

- Confirm that `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`) contain the correct values for the target environment.
- Ensure that any configuration keys previously stored in `Web.config` or `App.config` have been properly migrated to the new configuration system.

### 7. Check Target Framework Compatibility

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 8. Review Removed Windows-Specific Dependencies

Cross-platform .NET does not support certain Windows-specific APIs. Search the codebase for any usages of the following and replace or remove them if found:

- `System.Web` namespaces
- `HttpContext` from `System.Web` (should be replaced with `Microsoft.AspNetCore.Http`)
- Windows Registry access
- Any P/Invoke calls targeting Windows-only system libraries

### 9. Deploy to Target Environment

Once all local validation steps pass:

- Publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

- Copy the contents of the `./publish` directory to the target server or hosting environment.
- Confirm the runtime environment has the correct version of the .NET runtime installed.