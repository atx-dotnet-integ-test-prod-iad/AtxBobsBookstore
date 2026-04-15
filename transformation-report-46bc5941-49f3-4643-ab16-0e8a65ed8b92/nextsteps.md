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

Ensure consistency across all three projects. A mismatch between projects can cause runtime issues even when the build succeeds.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that core logic in `Bookstore.Domain` and `Bookstore.Data` behaves as expected:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider adding unit tests for critical domain logic and data access methods before proceeding further.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- Connection strings in `appsettings.json` are updated and valid for the target environment.
- If Entity Framework Core is in use, run the following to verify migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary features to confirm end-to-end functionality is intact.

### 7. Check for Removed Windows-Specific APIs

Even without build errors, certain APIs that were available in .NET Framework may have been silently replaced or may behave differently on non-Windows platforms. Review the code for usage of the following and test on the target platform if applicable:

- `System.Web` namespaces
- Windows Registry access
- Windows-specific authentication mechanisms (e.g., Windows Authentication, NTLM)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

### 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, confirm that the ASP.NET Core middleware pipeline is correctly configured in `Program.cs` or `Startup.cs`, including:

- Authentication and authorization middleware
- Static file serving
- Routing configuration
- Any custom HTTP modules or handlers that were migrated from the legacy project