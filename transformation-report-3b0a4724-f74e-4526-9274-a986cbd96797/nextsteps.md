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

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations or database connection strings are correctly configured for the new runtime. Check the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are valid and accessible.
- If using Entity Framework Core, run the following to verify the model against the database schema:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows such as browsing, searching, and any data entry features to confirm end-to-end behavior is intact.

### 7. Check for Windows-Specific API Usage

Even without build errors, the code may reference APIs that compile successfully but fail at runtime on non-Windows platforms. Search the codebase for usage of the following and evaluate whether platform-specific alternatives are needed:

- `Microsoft.Win32` namespaces
- `System.Drawing` (GDI+ based)
- Registry access
- Windows-specific file path assumptions (e.g., backslash separators)

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

### 8. Review Removed or Changed APIs

Cross-platform .NET removed several APIs that existed in .NET Framework. Run the .NET Upgrade Assistant compatibility analyzer or the Platform Compatibility Analyzer to surface any runtime risks:

```bash
dotnet add package Microsoft.DotNet.PlatformAbstractions
```

Alternatively, review the [.NET Framework to .NET compatibility documentation](https://learn.microsoft.com/en-us/dotnet/core/porting/net-framework-tech-unavailable) for APIs that may have been silently removed.