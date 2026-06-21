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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config`, including connection strings and application settings.
- Environment-specific configuration files such as `appsettings.Development.json` and `appsettings.Production.json` are present and correctly structured.
- Any configuration transformations that were previously handled by `Web.config` transforms are now handled through environment variables or `appsettings.{Environment}.json` files.

---

## 4. Verify Database Connectivity (Bookstore.Data)

If the project uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- The connection string in `appsettings.json` is valid and points to the correct database.
- Run any pending migrations to ensure the database schema is up to date.

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and confirm the application loads correctly.

---

## 6. Test Core Functionality

Manually verify the following areas of the application:

- All primary pages and routes load without errors.
- Database read and write operations function correctly (e.g., browsing books, adding records).
- Authentication and authorization, if present, behave as expected.
- Any file I/O operations use `Path.Combine` and avoid hardcoded Windows-style paths, which would cause failures on Linux or macOS.

---

## 7. Run Automated Tests (If Applicable)

If the solution contains a test project, execute the test suite to confirm existing behavior is preserved.

```bash
dotnet test
```

Review any failing tests and determine whether they reflect genuine regressions introduced during migration or tests that require updating to account for the new project structure.

---

## 8. Check for Remaining Platform-Specific Code

Search the codebase for APIs that are not supported on cross-platform .NET:

- `System.Web` references, which are not available outside of ASP.NET Core.
- Windows Registry access (`Microsoft.Win32.Registry`).
- Windows-only APIs such as `System.Drawing` (use a cross-platform alternative like `SkiaSharp` if image processing is required).

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining compatibility concerns.

---

## 9. Publish the Application

Once the application has been validated locally, publish it for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.