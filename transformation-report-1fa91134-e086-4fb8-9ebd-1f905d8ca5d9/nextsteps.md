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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without errors or warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically, as they are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that Entity Framework migrations (if applicable) are up to date. Run `dotnet ef database update` if needed.
- **Configuration**: Verify that `appsettings.json` contains all necessary configuration values that may have previously been stored in `Web.config` or `App.config`.
- **Static files and routing**: Confirm that pages, routes, and static assets load correctly in the browser.
- **Authentication and authorization**: If the application uses ASP.NET Identity or any middleware-based auth, verify that login and access control work as expected.

### 5. Check Target Framework Compatibility

Open each `.csproj` file and confirm that the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Review Removed or Changed APIs

Cross-platform .NET does not support certain Windows-specific APIs that were available in .NET Framework. Review the code in each project for any usage of the following, which may compile but fail at runtime:

- `System.Web` types
- Windows Registry access
- `HttpContext.Current`
- `ConfigurationManager` (should be replaced with `IConfiguration`)
- Any P/Invoke calls to Windows-only native libraries

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.