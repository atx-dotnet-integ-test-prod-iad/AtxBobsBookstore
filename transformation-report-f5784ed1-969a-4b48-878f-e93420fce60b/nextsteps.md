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

Ensure none of the projects are still referencing `net48` or any other Windows-only framework moniker unintentionally.

### 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining references to Windows-specific APIs or packages, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- `HttpContext` usage from `System.Web` (as opposed to `Microsoft.AspNetCore.Http`)

These will not cause build errors on Windows but will fail at runtime or when built on Linux or macOS.

### 5. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the displayed local URL and confirm the application loads without runtime exceptions.

### 6. Run Existing Tests

If a test project exists in the solution, execute the test suite to validate that existing functionality has not regressed:

```bash
dotnet test
```

Review any failing tests and determine whether they are caused by migration-related changes or pre-existing issues.

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the database connection string is correctly configured in `appsettings.json` and that any required migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

### 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, confirm that the application startup is using the modern ASP.NET Core pattern. If a `Startup.cs` file is still present, consider consolidating it into `Program.cs` using the minimal hosting model introduced in .NET 6.

### 9. Test on a Non-Windows Platform (Optional but Recommended)

To fully validate cross-platform compatibility, build and run the application on Linux or macOS, or within a non-Windows environment, to surface any remaining platform-specific issues that would not appear during a Windows build.