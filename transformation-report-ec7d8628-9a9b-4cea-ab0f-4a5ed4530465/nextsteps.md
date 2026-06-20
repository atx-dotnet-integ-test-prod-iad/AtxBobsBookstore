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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific APIs

Even without build errors, the code may still contain Windows-specific API calls that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any analyzer warnings related to platform-specific code paths, particularly in `Bookstore.Data` where database access or file I/O may be involved.

### 5. Run Existing Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding unit tests for the core domain logic in `Bookstore.Domain` and integration tests for the data access layer in `Bookstore.Data`.

### 6. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry flows, to confirm runtime behavior is correct.

### 7. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that any pending migrations are applied correctly:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project was migrated from Entity Framework 6, verify that the migration to EF Core was handled correctly, as EF Core has breaking differences in behavior and API surface.

### 8. Review Configuration Files

Check that `appsettings.json` contains all configuration values that were previously stored in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Any environment-specific overrides using `appsettings.Development.json`

### 9. Validate Static Assets and Middleware

If `Bookstore.Web` previously used ASP.NET Web Forms or ASP.NET MVC 5, confirm that static file serving, routing, and middleware are correctly configured in `Program.cs` or `Startup.cs` under the new ASP.NET Core pipeline.