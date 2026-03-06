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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their NuGet pages for recommended replacements compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project still references `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific APIs

Even without build errors, some APIs may have been carried over from the legacy project that only function correctly on Windows. Review the following areas:

- **`Bookstore.Data`**: Check for any use of `System.Data.SqlClient`. If present, consider replacing it with `Microsoft.Data.SqlClient`, which has cross-platform support.
- **`Bookstore.Web`**: Confirm that no `System.Web` references remain. These are not supported on cross-platform .NET.
- Look for any use of Windows registry access, COM interop, or `System.Drawing` (GDI+), as these may require additional packages or replacements on non-Windows platforms.

---

## 5. Run Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains a test project, execute all tests to validate that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and cross-platform .NET.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:
- The application starts without runtime exceptions.
- Core application routes and pages load correctly.
- Database read and write operations function as expected.
- Any authentication or session handling works correctly.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains all necessary configuration values that may have previously resided in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Logging configuration
- Application-specific settings

`Web.config` and `App.config` are not used by cross-platform .NET in the same way. Ensure all relevant values have been migrated to `appsettings.json` or environment variables.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and dependencies are present.