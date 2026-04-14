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

If the solution contains test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly and that Entity Framework migrations (if applicable) are up to date. Run `dotnet ef database update` if needed.
- **Domain logic**: Exercise the core domain functionality through the UI or API endpoints to confirm correct behavior.
- **Configuration**: Verify that `appsettings.json` contains all necessary configuration values that were previously in `Web.config` or `App.config`, including connection strings and application settings.
- **Static assets and routing**: Navigate through the web application to confirm that pages render correctly and routing behaves as expected.

### 5. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that behave differently in cross-platform .NET compared to .NET Framework. Common areas to check include:

- `System.Web` dependencies, which are not available in cross-platform .NET and should have been replaced with ASP.NET Core equivalents.
- Windows-specific APIs such as the registry, certain cryptography providers, or `System.Drawing` (GDI+), which may require alternative packages like `System.Drawing.Common` or replacements.
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET.

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-framework compatibility issues.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all expected files, including configuration files and static assets, are present before deploying to the target environment.