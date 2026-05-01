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

Run the following command from the root of the solution to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Verify that the restore completes without warnings or errors related to missing packages or incompatible target frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent compilation.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test
```

Review any failing tests and determine whether they are caused by behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and routing
- Database connectivity from `Bookstore.Data` (verify connection strings are correctly configured for the new environment)
- Domain logic correctness through the UI or API endpoints

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm that:

- Connection strings are valid and point to the correct database instances
- Any settings previously stored in `Web.config` or `App.config` have been correctly migrated to the new configuration system

### 6. Check Target Framework Compatibility

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported framework version.

### 7. Review Removed or Changed APIs

Check for any use of APIs that were available in .NET Framework but have changed behavior or limited support in cross-platform .NET, including:

- `System.Web` references (should no longer be present)
- Windows-specific APIs that may not function on Linux or macOS
- Entity Framework version differences between `Bookstore.Data` and the new runtime

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, static assets, and dependencies are present before deploying to the target environment.