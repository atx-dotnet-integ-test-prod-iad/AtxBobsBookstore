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

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically, as they are common sources of subtle runtime differences after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database and performs reads and writes correctly. Pay attention to any Entity Framework Core migration differences if you migrated from EF6.
- **Configuration**: Verify that settings previously stored in `Web.config` or `App.config` have been correctly moved to `appsettings.json` and are being read at runtime.
- **Static files and routing**: Confirm that pages, routes, and static assets load as expected in the web layer.
- **Authentication and authorization**: If the application uses any authentication middleware, verify that it initializes and functions correctly under the new runtime.

### 5. Check for Removed or Changed APIs

Review the code in each project for any use of APIs that exist in .NET Framework but behave differently or have been removed in cross-platform .NET. The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Microsoft.DotNet.PlatformAbstractions](https://learn.microsoft.com/en-us/dotnet/core/compatibility/) breaking changes documentation can assist with this review.

Key areas to check:

- `System.Web` references, which are not available in cross-platform .NET
- Any Windows-specific APIs (registry access, WCF server-side, etc.)
- Serialization behavior changes, particularly with `System.Text.Json` vs `Newtonsoft.Json`

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and currently supported version of .NET.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct before deploying:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assemblies, configuration files, and static assets are present.