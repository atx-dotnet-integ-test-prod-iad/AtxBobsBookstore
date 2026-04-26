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

Check the output for any warnings that, while non-blocking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by test setup issues.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- The database provider package (e.g., Entity Framework Core, Dapper) is compatible with the target .NET version.
- Connection strings in configuration files (`appsettings.json`) are correct and accessible in the new environment.
- Any migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 6. Verify Runtime Behavior (Bookstore.Web)

Start the web application locally and navigate through its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check for any runtime exceptions, particularly around:

- Authentication and authorization middleware
- Static file serving
- Any Windows-specific APIs that may have been used in the legacy project (e.g., `System.Web` references, Windows Registry access, COM interop)

### 7. Review Configuration

Ensure that configuration previously handled by `Web.config` or `App.config` has been properly migrated to `appsettings.json` or environment variables. Confirm that environment-specific settings (e.g., development vs. production connection strings) are handled using the `IConfiguration` pattern.

### 8. Check for Platform-Specific Code

Search the codebase for any remaining platform-specific APIs that may compile successfully on Windows but fail on Linux or macOS:

```bash
grep -rn "Registry\|Environment.GetFolderPath\|System.Web\|HttpContext.Current" app/
```

Address any findings by replacing them with cross-platform equivalents available in .NET.