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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid interoperability issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting critical areas such as domain logic in `Bookstore.Domain` and data access in `Bookstore.Data`.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The connection string in `appsettings.json` is valid and points to the correct database.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The EF Core provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is appropriate for the target database.

### 6. Run the Web Application Locally

Start the web application to verify it runs correctly end to end:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows such as browsing, searching, and any data entry features to confirm they function as expected.

### 7. Review Removed Windows-Specific APIs

Search the codebase for any APIs that were commonly used in legacy .NET Framework projects and may have limited or no support on cross-platform .NET:

- `System.Web` references
- `HttpContext` usage outside of ASP.NET Core's dependency injection
- `ConfigurationManager` (should be replaced with `IConfiguration`)
- Windows Registry access
- `System.Drawing` (consider replacing with a cross-platform alternative such as `SkiaSharp` if image processing is needed)

```bash
grep -rn "System.Web\|ConfigurationManager\|System.Drawing" --include="*.cs" .
```

Address any findings before considering the migration complete.

### 8. Test on a Non-Windows Environment (Optional but Recommended)

Since the goal of the transformation is cross-platform compatibility, run the application on Linux or macOS if possible to surface any remaining platform-specific issues:

```bash
dotnet run --project Bookstore.Web
```

Review any runtime exceptions that do not appear on Windows.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce a deployment-ready output:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all required files are present, including:

- The application binary or `Bookstore.Web.dll`
- `appsettings.json` and any environment-specific configuration files
- Static web assets under `wwwroot`

### 3. Configure Environment-Specific Settings

Ensure that sensitive configuration values such as connection strings are not hardcoded in `appsettings.json`. Use environment variables or a secrets manager appropriate for the target hosting environment to supply these values at runtime.