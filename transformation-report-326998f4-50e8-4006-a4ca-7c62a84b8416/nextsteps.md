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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-specific framework moniker such as `net48-windows`.

### 4. Check for Windows-Specific Dependencies

Inspect each project's `.csproj` for any NuGet packages or references that are Windows-only. Common examples include:

- `Microsoft.Web.Infrastructure`
- `System.Web` references
- Any package with a `windows` target framework condition

These will not function correctly on Linux or macOS.

### 5. Run Unit Tests

If the solution contains test projects, execute them to validate that core logic has not been affected by the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by framework-level behavioral differences.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, particularly any that involve data access through `Bookstore.Data` and domain logic in `Bookstore.Domain`.

### 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that any pending migrations are applied and that the connection string in `appsettings.json` is correct for the target environment:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project migrated from Entity Framework 6, confirm that the migration to EF Core was handled, as EF6 is not supported on cross-platform .NET.

### 8. Review Configuration and Middleware

If the project was previously an ASP.NET MVC application, confirm that:

- `Startup.cs` or `Program.cs` has been updated to use the ASP.NET Core middleware pipeline.
- `Web.config` settings have been moved to `appsettings.json` or environment variables where applicable.
- Authentication, authorization, and session configurations have been updated to their ASP.NET Core equivalents.

### 9. Test on a Non-Windows Platform (Optional but Recommended)

To confirm true cross-platform compatibility, run the application on Linux or macOS if possible. This will surface any remaining platform-specific dependencies that may not be apparent on Windows.