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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target framework version.
- Connection strings in configuration files (`appsettings.json`) are correct and accessible in the new environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of sync, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm runtime behavior is correct.

### 7. Review Configuration Files

Check `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) to ensure:

- No references to Windows-specific paths or registry-based configuration remain.
- Logging, authentication, and other middleware settings are correct for the new runtime.

### 8. Check for Remaining Windows-Specific APIs

Even without build errors, some APIs may compile successfully but fail at runtime on non-Windows platforms. Search the codebase for common problem areas:

- `Microsoft.Win32` namespace usage
- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)
- Windows registry access
- Hardcoded Windows file path separators (`\`)

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

### 9. Test on the Target Platform

If the intended deployment target is Linux or macOS, run and test the application on that operating system (or an equivalent environment) to surface any platform-specific runtime issues that would not appear on Windows.