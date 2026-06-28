# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

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

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Ensure the build output reports zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any remaining Windows-specific dependencies such as:

- `System.Web` references
- Windows Registry access
- `HttpContext` usage patterns tied to the old ASP.NET pipeline
- WCF or ASMX service references

These will not function correctly on non-Windows platforms and will need to be replaced with cross-platform equivalents.

---

## 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core package is referenced instead of the legacy `EntityFramework` package.
- The `DbContext` configuration uses the new `OnConfiguring` or `AddDbContext` pattern.
- Run any pending migrations to validate schema compatibility:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains a test project, execute the tests to validate that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected.

```bash
dotnet test
```

Review test results for failures that may indicate behavioral differences introduced by the framework migration.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality such as browsing, searching, and any data-driven pages.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the console output for runtime exceptions, middleware configuration issues, or missing configuration values in `appsettings.json`.

---

## 8. Validate Configuration

Confirm that all settings previously stored in `Web.config` or `App.config` have been migrated to `appsettings.json` or environment variables. Pay particular attention to:

- Connection strings
- Application-specific keys
- Logging configuration

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before copying them to the target environment.