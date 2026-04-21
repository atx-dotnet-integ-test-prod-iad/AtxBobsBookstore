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

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Search the codebase for any APIs or packages that are Windows-only, such as:

- `Microsoft.Win32` registry access
- `System.Windows.Forms`
- `System.Drawing` (without the `System.Drawing.Common` cross-platform package)
- Any P/Invoke calls targeting Windows DLLs

These will not cause build errors on Windows but will fail at runtime on Linux or macOS.

### 5. Run Unit Tests

If the solution contains test projects, execute them to verify runtime behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests for regressions introduced during the migration.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- Application starts without exceptions
- Database connectivity works (check connection strings in `appsettings.json` for any Windows-specific paths or authentication modes such as Windows Integrated Security)
- All major application routes and pages load correctly

### 7. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files for settings that may be environment-dependent:

- **Connection strings**: Replace Windows Authentication (`Integrated Security=True`) with SQL username/password authentication or another cross-platform-compatible method if targeting non-Windows hosts.
- **File paths**: Replace any hardcoded Windows-style paths (e.g., `C:\`) with relative paths or environment variables.

### 8. Verify Entity Framework Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that migrations are up to date and can be applied:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations to a test database to confirm schema compatibility:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```