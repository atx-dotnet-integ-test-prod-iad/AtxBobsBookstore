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

Ensure the output reports zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were removed or significantly changed in modern .NET. Common areas to check include:

- `System.Web` references, which are not available outside of .NET Framework
- `HttpContext` and related ASP.NET types in `Bookstore.Web`
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET
- `ConfigurationManager`, which requires the `System.Configuration.ConfigurationManager` NuGet package if still in use

---

## 5. Verify Database Connectivity in Bookstore.Data

If `Bookstore.Data` uses Entity Framework, confirm the correct version is referenced:

- **Entity Framework Core** is required for cross-platform .NET. The legacy `EntityFramework` (6.x) package targeting .NET Framework is not compatible.
- Check that the `DbContext` configuration and migrations are compatible with EF Core conventions.

Run any existing migrations against a development database to confirm schema compatibility:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application to verify it runs correctly on the local development machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, to confirm basic functionality.

---

## 7. Run Existing Tests

If a test project exists in the solution, execute the test suite to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 8. Review Application Configuration

Check `appsettings.json` (or `appsettings.Development.json`) in `Bookstore.Web` to ensure:

- Connection strings are correctly defined for the target environment
- Any configuration keys previously stored in `Web.config` or `App.config` have been migrated to the appropriate `appsettings.json` structure
- Environment-specific settings are separated appropriately

---

## 9. Validate Static Files and Views

If `Bookstore.Web` is an ASP.NET Core application, confirm that:

- Static files (CSS, JavaScript, images) are located under the `wwwroot` folder
- Razor views or pages render correctly without missing layout or partial view errors
- Any Razor syntax that relied on legacy `System.Web.Mvc` helpers has been updated to ASP.NET Core equivalents