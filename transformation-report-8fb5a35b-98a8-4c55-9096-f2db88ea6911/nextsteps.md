# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, confirm that any database connection strings in `appsettings.json` or `appsettings.Production.json` are correctly configured for the target environment. If Entity Framework Core is in use, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of date, generate and apply them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output and verify that the application loads and behaves correctly, including any data-driven pages that depend on `Bookstore.Data` and `Bookstore.Domain`.

### 6. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid any inter-project compatibility issues.

### 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Manually review the following areas if they were present in the original project:

- `System.Web` usages — these are not available in .NET Core or later and must be replaced with ASP.NET Core equivalents.
- `HttpContext` access patterns — ensure these use the ASP.NET Core `IHttpContextAccessor` where needed.
- Any Windows-specific libraries or registry access — these will not function on non-Windows platforms.

### 8. Check Runtime Configuration Files

Verify that the following configuration files are present and correctly structured in `Bookstore.Web`:

- `appsettings.json`
- `appsettings.Development.json`
- `Program.cs` — confirm it follows the ASP.NET Core hosting model appropriate for the target framework version.