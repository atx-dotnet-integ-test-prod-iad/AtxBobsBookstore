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

Review the output for any warnings related to package compatibility or missing packages.

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

Review test results and address any failures before proceeding.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Windows-Specific APIs

Even without build errors, the code may still reference Windows-specific APIs that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these issues:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any analyzer warnings that appear after rebuilding.

### 6. Review Entity Framework or Data Access Configuration

In `Bookstore.Data`, verify that any database provider configuration (e.g., connection strings, provider registration) is compatible with the target runtime and environment. Pay particular attention to:

- Connection string formats
- Database provider NuGet packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, etc.)
- Migration compatibility with the new framework version

### 7. Run the Application Locally

Start the web application and perform manual smoke testing:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and verify that core functionality such as page rendering, data retrieval, and form submissions behave as expected.

### 8. Review Startup and Middleware Configuration

In `Bookstore.Web`, inspect `Program.cs` or `Startup.cs` to confirm that middleware, dependency injection registrations, and configuration sources have been correctly migrated to the modern .NET hosting model. Legacy patterns such as `WebHost.CreateDefaultBuilder` should be replaced with `WebApplication.CreateBuilder` where applicable.

### 9. Validate Configuration Files

Confirm that `appsettings.json` and any environment-specific variants (e.g., `appsettings.Development.json`) are present and contain the correct configuration values for the target environment.

### 10. Deploy to a Staging Environment

Once local validation is complete, publish the application and deploy it to a staging environment that mirrors production:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the application runs correctly in the staging environment before promoting to production.