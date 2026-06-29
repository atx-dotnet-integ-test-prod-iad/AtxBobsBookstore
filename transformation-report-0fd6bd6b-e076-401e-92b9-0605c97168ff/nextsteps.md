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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage warnings
- Platform compatibility warnings

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config` (connection strings, app settings, etc.).
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate.
- Confirm that `Bookstore.Data` is reading connection strings from the new configuration system (`IConfiguration`) rather than `ConfigurationManager`.

---

## 4. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core package is referenced (e.g., `Microsoft.EntityFrameworkCore`).
- The database provider package matches your database (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify:
- Pages load without errors
- Data is read from and written to the database correctly
- Authentication and authorization behave as expected, if applicable

---

## 6. Execute Automated Tests

If the solution contains a test project, run all tests to confirm existing functionality has not regressed:

```bash
dotnet test
```

Review the test results and investigate any failures. If no test project currently exists, consider adding one targeting critical areas such as domain logic in `Bookstore.Domain` and data access in `Bookstore.Data`.

---

## 7. Check for Removed or Changed APIs

Some .NET Framework APIs are not available or have changed in cross-platform .NET. Use the .NET Upgrade Assistant compatibility analyzer or review the Microsoft documentation for known breaking changes:

- [Breaking changes in .NET](https://learn.microsoft.com/en-us/dotnet/core/compatibility/)

Pay particular attention to:
- `System.Web` namespace usage (not available in cross-platform .NET)
- `HttpContext` access patterns
- Any Windows-specific APIs that may not function on Linux or macOS

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to your intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Ensure consistency across all three projects unless there is a specific reason for them to differ.