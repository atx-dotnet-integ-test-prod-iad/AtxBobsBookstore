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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Inspect the `Bookstore.Data` and `Bookstore.Web` projects for any packages or APIs that are Windows-only. Common areas to check include:

- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)
- Windows Registry access
- `Microsoft.Win32` namespace usage
- Any package marked with `[SupportedOSPlatform("windows")]`

Run the following to surface platform compatibility analyzer warnings:

```bash
dotnet build -p:EnableNETAnalyzers=true
```

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify functional correctness after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether failures are caused by behavioral differences in the new runtime or by migration-related changes.

---

## 6. Validate the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to validate:

- Application startup with no unhandled exceptions
- Database connectivity from `Bookstore.Data` (verify connection strings in `appsettings.json`)
- All major user-facing routes and pages load correctly
- Any authentication or authorization flows behave as expected

---

## 7. Verify Database Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date and apply cleanly against the target database.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj

dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project was previously using EF 6 (not EF Core), a separate migration from EF 6 to EF Core may be required.

---

## 8. Review Configuration and Environment Settings

Confirm that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` and that environment-specific overrides are in place where needed.

Check that the following are present and correctly configured in `Bookstore.Web`:

- `appsettings.json`
- `appsettings.Development.json` (for local development settings)
- Connection strings
- Any application-level settings previously in `<appSettings>` or `<connectionStrings>` sections

---

## 9. Publish the Application

Once all validation steps pass, publish the application to confirm the output is complete and self-contained.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the `./publish` directory to confirm all required files are present before deploying to the target environment.