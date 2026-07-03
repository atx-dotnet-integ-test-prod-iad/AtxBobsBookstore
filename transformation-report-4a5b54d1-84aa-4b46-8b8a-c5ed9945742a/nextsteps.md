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

Ensure none of the projects still reference `net48` or any other Windows-specific framework moniker unless intentional.

### 4. Check for Windows-Specific Dependencies

Review the dependencies in each project for any packages or APIs that are Windows-only. Common areas to inspect include:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows Registry access via `Microsoft.Win32`.
- Any P/Invoke calls targeting Windows-specific native libraries.

Run the .NET Upgrade Assistant compatibility analyzer if a deeper audit is needed:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze
```

### 5. Run Unit Tests

If the solution contains a test project, execute the test suite to validate runtime behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests, as they may surface runtime issues that are not visible at compile time.

### 6. Run the Application Locally

Start the `Bookstore.Web` project locally to validate basic functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at a minimum:

- Application startup without exceptions.
- Database connectivity through `Bookstore.Data`.
- Core domain logic in `Bookstore.Domain` functioning as expected through the UI or API endpoints.

### 7. Verify Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, confirm that migrations are up to date and compatible with the new framework version:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or outdated, add a new migration and apply it to the target database:

```bash
dotnet ef migrations add PostMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files are present and correctly structured. Legacy `Web.config` or `App.config` files should have their relevant settings migrated to `appsettings.json` if that has not already been done.