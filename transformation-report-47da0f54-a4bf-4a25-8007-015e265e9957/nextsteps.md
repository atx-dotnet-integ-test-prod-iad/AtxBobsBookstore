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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

### 5. Verify Data Layer

Since `Bookstore.Data` likely interacts with a database, confirm the following:

- The correct Entity Framework Core (or other ORM) packages are referenced.
- Any database migrations are compatible with the new runtime.
- Connection strings in configuration files (`appsettings.json`) are correct and accessible.

Run a quick connectivity check by launching the application and performing a basic data retrieval operation.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and navigate through the application to verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- Application startup with no runtime exceptions.
- All major routes and pages load correctly.
- Forms and data submission work as expected.
- Static assets (CSS, JavaScript, images) are served correctly.

### 7. Check for Removed or Changed APIs

Review the code for any usage of APIs that were available in .NET Framework but have changed behavior or been removed in modern .NET. Common areas to inspect include:

- `System.Web` references, which are not available in modern .NET.
- `HttpContext` usage patterns.
- Configuration APIs (`ConfigurationManager` vs `Microsoft.Extensions.Configuration`).
- Any Windows-specific APIs if cross-platform support is required.

### 8. Review Application Logs

After running the application, review the console and any file-based logs for runtime warnings or errors that would not surface during a build.