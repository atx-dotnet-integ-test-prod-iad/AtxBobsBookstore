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

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless intentional.

### 4. Check for Windows-Specific APIs

Even without build errors, the code may still contain Windows-specific API calls that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any reported diagnostics, particularly in `Bookstore.Data` where database or file system access is likely to occur.

### 5. Run Existing Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test --configuration Release
```

If no tests exist, consider writing basic integration tests that cover:

- Database connectivity and CRUD operations in `Bookstore.Data`
- Core domain logic in `Bookstore.Domain`
- Key HTTP endpoints in `Bookstore.Web`

### 6. Verify Database Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migration to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and managing books, to confirm end-to-end functionality.

### 8. Review Configuration Files

Inspect `appsettings.json` and any environment-specific variants such as `appsettings.Production.json` to confirm:

- Connection strings are valid for the target environment
- Any paths previously using Windows-style backslashes (`\`) have been updated to use forward slashes (`/`) or `Path.Combine` in code
- Any references to Windows registry or Windows-specific configuration sources have been removed or replaced

### 9. Test on the Target Platform

If the goal is to run on Linux or macOS, perform a test run on that operating system to catch any remaining platform-specific issues that would not surface on Windows, even with a clean build.