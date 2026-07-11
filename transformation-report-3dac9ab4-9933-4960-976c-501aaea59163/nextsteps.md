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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their cross-platform equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings (CA1416)

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config`, including connection strings and application settings.
- `appsettings.Development.json` exists for environment-specific overrides.
- Any `<connectionStrings>` or `<appSettings>` entries from the old `Web.config` have been migrated to `appsettings.json`.

---

## 4. Verify the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to a version compatible with cross-platform .NET.
- If using Entity Framework Core, verify that the `DbContext` configuration uses `optionsBuilder` in `OnConfiguring` or is registered via dependency injection in `Program.cs`.
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate that business logic and data access behavior is preserved after migration.

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral differences introduced by the migration. Pay particular attention to:
- Date and time handling
- String comparison behavior
- File path handling (use `Path.Combine` for cross-platform compatibility)

---

## 6. Run the Application Locally

Start the web application locally and verify core functionality.

```bash
dotnet run --project Bookstore.Web
```

Manually verify the following areas:
- Application startup with no runtime exceptions
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Static file serving (CSS, JavaScript, images)

---

## 7. Check for Runtime-Only Issues

Some issues do not surface at compile time. During local testing, monitor the application for:
- Missing middleware registrations in `Program.cs` or `Startup.cs`
- Incorrect service lifetimes registered in the dependency injection container
- Any use of `HttpContext.Current`, which is not available in cross-platform .NET and must be replaced with `IHttpContextAccessor`
- Any use of `System.Web` APIs that may have been stubbed out during transformation

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, including static assets and configuration files. Verify that no sensitive configuration values are hardcoded in published files.