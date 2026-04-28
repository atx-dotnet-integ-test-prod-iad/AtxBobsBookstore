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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they indicate regressions introduced during the migration.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another ORM, confirm the following:

- Connection strings in `appsettings.json` are valid and accessible in the new environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm runtime behavior is correct.

### 7. Review Removed Windows-Specific APIs

Search the codebase for any APIs that were commonly used in .NET Framework but are unavailable or behave differently in cross-platform .NET:

- `System.Web` references
- `HttpContext` usage outside of the ASP.NET Core request pipeline
- `ConfigurationManager` (should be replaced with `IConfiguration`)
- Windows Registry access
- `AppDomain` members that are no longer supported

```bash
grep -rn "System.Web\|ConfigurationManager\|Registry" --include="*.cs" .
```

Address any findings by replacing them with their cross-platform equivalents.

### 8. Check for Nullable Reference Type Warnings

If the projects have `<Nullable>enable</Nullable>` set, review nullable warnings in the build output and update code accordingly to prevent potential null reference exceptions at runtime.

### 9. Review Middleware and Startup Configuration (Bookstore.Web)

If the project was migrated from ASP.NET MVC (.NET Framework) to ASP.NET Core, confirm that:

- `Program.cs` correctly configures services and middleware.
- Authentication, authorization, and routing are configured using the ASP.NET Core equivalents.
- Static files, session, and any custom HTTP modules or handlers have been replaced with ASP.NET Core middleware.

### 10. Manual Smoke Test

Perform a manual walkthrough of the application's core features to identify any runtime issues that automated tests may not cover.