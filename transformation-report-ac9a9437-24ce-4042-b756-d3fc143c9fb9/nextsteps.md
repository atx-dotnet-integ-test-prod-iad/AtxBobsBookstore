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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas where the migration introduced subtle issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid cross-framework compatibility issues.

---

## 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- The database can be reached and updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Review Configuration Files (Bookstore.Web)

Legacy projects often rely on `Web.config` or `App.config`. In cross-platform .NET, configuration is handled through `appsettings.json`. Confirm that:

- Connection strings have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`.
- The `Program.cs` and `Startup.cs` (if present) correctly load configuration using `IConfiguration`.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application's key pages and features to confirm that:

- Pages render correctly.
- Data is read from and written to the database as expected.
- No unhandled exceptions appear in the console output.

---

## 8. Review Middleware and HTTP Pipeline

If `Bookstore.Web` was migrated from ASP.NET (System.Web) to ASP.NET Core, review the HTTP middleware pipeline in `Program.cs` to ensure the following are configured where applicable:

- `app.UseRouting()`
- `app.UseAuthentication()` / `app.UseAuthorization()`
- `app.UseStaticFiles()`
- `app.UseSession()`

Missing middleware registrations are a common source of runtime issues that do not surface as build errors.

---

## 9. Check for Platform-Specific Code

Search the solution for any remaining Windows-specific APIs that may cause issues on non-Windows platforms:

- `Microsoft.Win32` namespace usage
- `System.Web` references
- Windows registry access
- COM interop

These will not always produce build errors but will cause runtime failures on Linux or macOS.

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.