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

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically, as they are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that Entity Framework migrations (if any) are up to date. Run `dotnet ef database update` if needed.
- **Configuration**: Verify that `appsettings.json` contains all necessary configuration values that may have previously lived in `Web.config` or `App.config`.
- **Static files and routing**: Confirm that pages, routes, and static assets load correctly in the browser.
- **Authentication and authorization**: If the application uses any authentication middleware, verify that login and access control behave as expected.

### 5. Check for Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas manually:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows-specific APIs such as the registry, WCF server-side components, or `System.Drawing` (GDI+), which may require replacement packages or alternative implementations.
- Any third-party libraries that were targeting .NET Framework exclusively. Verify that compatible versions exist on NuGet.

### 6. Review Warnings

Even without errors, the build may have produced warnings. Review them with:

```bash
dotnet build --configuration Release 2>&1 | grep -i warning
```

Address any warnings related to deprecated APIs or obsolete package references, as these may become errors in future .NET versions.

### 7. Validate Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for a web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Ensure consistency across all projects in the solution.

## Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment. Ensure the target environment has the correct .NET runtime version installed. You can verify the required runtime version from the `<TargetFramework>` value in the `.csproj` file.