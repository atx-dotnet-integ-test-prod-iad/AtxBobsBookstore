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

Check the output for any warnings that may indicate compatibility concerns, even if they do not prevent compilation.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-specific framework moniker unless intentional.

### 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining references to Windows-only APIs or packages, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- `HttpContext` usage from `System.Web` rather than `Microsoft.AspNetCore.Http`

These will not always produce build errors but can cause runtime failures on non-Windows platforms.

### 5. Run Unit Tests

If the solution contains test projects, execute them to validate core logic:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences introduced during the migration.

### 6. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and verify:

- Pages load without errors
- Database connectivity functions correctly (`Bookstore.Data`)
- Domain logic behaves as expected (`Bookstore.Domain`)

### 7. Verify Database Migrations

If the project uses Entity Framework Core, confirm that existing migrations are compatible with the new setup:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations were originally written for EF 6, they may need to be recreated for EF Core.

### 8. Review Configuration Files

Confirm that `appsettings.json` contains the correct configuration values that were previously held in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

### 9. Test on a Non-Windows Platform (Optional but Recommended)

If cross-platform support is a goal, run the application on Linux or macOS to surface any platform-specific runtime issues that would not appear on Windows.