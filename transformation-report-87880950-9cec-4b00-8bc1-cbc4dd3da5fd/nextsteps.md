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

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless explicitly required.

### 4. Check for Windows-Specific Dependencies

Inspect each project for NuGet packages or APIs that are Windows-only. Common areas to check include:

- `System.Drawing.Common` — restricted on non-Windows platforms in .NET 6+
- `Microsoft.Win32` namespaces
- Any COM interop references
- `System.Web` references, which are not available in cross-platform .NET

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `dotnet-compatibility` tool to surface these issues:

```bash
dotnet tool install -g dotnet-compatibility
```

### 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify runtime behavior has not changed:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they reflect genuine regressions introduced by the migration or test setup issues related to the new framework.

### 6. Verify Entity Framework or Data Access Layer

Since the solution includes a `Bookstore.Data` project, confirm the following:

- The EF Core provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is referenced and up to date.
- Any database migrations are still valid by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are out of sync, consider adding a new migration:

```bash
dotnet ef migrations add PostMigration --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary functionality, including any pages that interact with the data layer, to confirm end-to-end behavior is intact.

### 8. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, if possible, run the application on Linux or macOS to surface any remaining platform-specific issues:

```bash
dotnet run --project Bookstore.Web
```

Check application logs for runtime exceptions that would not appear during a Windows build.