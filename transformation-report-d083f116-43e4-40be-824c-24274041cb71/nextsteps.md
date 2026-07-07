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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and consistent cross-platform .NET version (e.g., `net8.0`). Mixing target frameworks across projects can cause runtime issues even when the build succeeds.

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another ORM, confirm the following:

- The connection string in `appsettings.json` is valid for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the selected target framework version.

### 6. Run the Web Application Locally

Start the web application to verify it runs correctly end to end:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm that routing, data access, and rendering all function as expected.

### 7. Review Removed or Changed APIs

Cross-platform .NET does not include certain APIs that were available in .NET Framework. Review the following areas manually:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET.
- `HttpContext` usage patterns, which differ between ASP.NET and ASP.NET Core.
- Configuration access patterns, which have moved from `ConfigurationManager` to `IConfiguration`.
- Any Windows-specific APIs (e.g., registry access, WCF server-side hosting) that may have been silently removed or stubbed.

### 8. Check for Nullable Reference Type Warnings

If the projects have nullable reference types enabled (`<Nullable>enable</Nullable>`), review any compiler warnings related to nullability. These are not errors by default but can indicate potential null reference exceptions at runtime.

### 9. Review Middleware and Startup Configuration (Bookstore.Web)

If the project was migrated from ASP.NET MVC to ASP.NET Core, confirm that the middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured, including:

- Authentication and authorization middleware ordering.
- Static file serving.
- Routing configuration.
- Any custom HTTP modules or handlers that may have been converted to middleware.