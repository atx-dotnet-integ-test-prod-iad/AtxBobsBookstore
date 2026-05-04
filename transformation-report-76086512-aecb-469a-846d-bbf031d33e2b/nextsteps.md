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

Check the output for any warnings that, while non-blocking, may indicate deprecated APIs or framework-specific code that could cause runtime issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new target framework.

### 4. Verify Runtime Behavior

Start the `Bookstore.Web` project and manually verify core application flows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, confirm the following areas function correctly, as they are common sources of runtime issues after migration:

- **Database connectivity**: Verify that `Bookstore.Data` connects to the database and that any Entity Framework migrations are up to date. Run pending migrations if necessary:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Configuration**: Confirm that settings previously in `Web.config` or `App.config` have been correctly transferred to `appsettings.json` and are being read at runtime.
- **Static files and routing**: Navigate through the web application to confirm that pages load correctly and routing behaves as expected.
- **Authentication and Authorization**: If the application uses any authentication middleware, verify that login and access control work as intended.

### 5. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Review the following areas manually:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET.
- `HttpContext` usage, which should now come from `Microsoft.AspNetCore.Http`.
- Any Windows-specific APIs (e.g., registry access, WCF server-side, `System.Drawing` without a compatibility package) that may compile but fail at runtime on non-Windows platforms.

### 6. Check the Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and currently supported version of .NET.

### 7. Review NuGet Package Versions

Confirm that all NuGet packages in use are compatible with the target framework and are reasonably up to date. Pay particular attention to:

- Entity Framework Core packages in `Bookstore.Data`
- ASP.NET Core packages in `Bookstore.Web`
- Any third-party libraries that may have separate packages for .NET Framework versus cross-platform .NET