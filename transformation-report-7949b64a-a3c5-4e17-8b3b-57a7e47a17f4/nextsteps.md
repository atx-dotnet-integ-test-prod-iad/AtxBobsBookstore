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

Check the build output for any warnings, particularly around nullable reference types, obsolete APIs, or platform compatibility annotations, as these can indicate areas that may cause runtime issues even if the build succeeds.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failures that were not present before the migration should be investigated, as they may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Check for Platform-Specific API Usage

Even without build errors, some APIs that compiled successfully may not behave correctly on non-Windows platforms. Review the following areas in particular:

- **`Bookstore.Data`**: Verify that any database connection strings or file paths use cross-platform conventions. If Entity Framework is used, confirm the provider is compatible with the target .NET version.
- **`Bookstore.Web`**: Check that any middleware, authentication configuration, or static file handling aligns with the ASP.NET Core model. Legacy `System.Web` patterns do not exist in ASP.NET Core and would have required replacement during transformation.
- **`Bookstore.Domain`**: Confirm that any serialization, reflection, or culture-sensitive operations produce consistent results on the new runtime.

### 5. Review Configuration Files

Ensure that `appsettings.json` (or equivalent) contains all necessary configuration that was previously held in `Web.config` or `App.config`. Pay attention to:

- Connection strings
- Application settings keys
- Logging configuration
- Authentication or authorization settings

### 6. Run the Application Locally

Start the application and perform manual smoke testing of core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the primary user flows, such as browsing books, and verify that data is loaded and displayed correctly.

### 7. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element specifies the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid version mismatch issues at runtime.

### 8. Address Any Runtime Warnings

After running the application, review the console output and application logs for runtime warnings or exceptions that did not surface at build time. Common post-migration issues include:

- Missing middleware registration
- Changed default behaviors in ASP.NET Core (e.g., routing, model binding)
- Differences in JSON serialization defaults between `Newtonsoft.Json` and `System.Text.Json`