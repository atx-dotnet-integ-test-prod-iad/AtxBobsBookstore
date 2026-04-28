# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects (`Bookstore.Data`, `Bookstore.Web`, or `Bookstore.Domain`). The solution compiles cleanly across all projects.

## Validation Steps

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the error-free state is consistent:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-breaking, may indicate areas of concern such as obsolete APIs or nullable reference warnings.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project is still referencing `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining Windows-specific APIs or packages. Common areas to check:

- Any usage of `System.Web` (not available in cross-platform .NET)
- References to `Microsoft.AspNet.*` packages (should be replaced with `Microsoft.AspNetCore.*`)
- Registry access, WCF server-side components, or Windows-only P/Invoke calls

Run the .NET Upgrade Assistant compatibility analyzer if a deeper audit is needed:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze
```

### 5. Run Unit Tests

If the solution contains a test project, execute all tests to verify runtime behavior has not changed:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 6. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, verify the following:

- The connection string format is compatible with the updated data provider.
- If Entity Framework is in use, confirm migrations are up to date by running:

```bash
dotnet ef database update
```

- If using EF Core, confirm the correct provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is referenced and that the `DbContext` configuration uses the new `IServiceCollection`-based setup.

### 7. Test the Web Application Locally

Run the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

- Navigate through key pages and workflows.
- Check for runtime exceptions that would not surface at compile time.
- Review application logs for any unhandled exceptions or middleware configuration issues.

### 8. Verify Configuration Files

Ensure that any `Web.config` or `App.config` settings have been properly migrated to `appsettings.json` or `appsettings.{Environment}.json`. The legacy XML-based configuration system is not used in cross-platform .NET applications.

### 9. Check Middleware and Startup Configuration

If `Bookstore.Web` is an ASP.NET Core application, review `Program.cs` (and `Startup.cs` if present) to confirm:

- All required services are registered in the dependency injection container.
- Middleware is ordered correctly (e.g., authentication before authorization).
- Static files, routing, and error handling are configured appropriately.