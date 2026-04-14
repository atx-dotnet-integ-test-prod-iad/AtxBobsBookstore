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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

These will not function on Linux or macOS and will require replacement with cross-platform equivalents.

---

## 5. Validate Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct EF Core package is referenced and that any database migrations are still valid.

```bash
dotnet ef dbcontext info --project Bookstore.Data
dotnet ef migrations list --project Bookstore.Data
```

If migrations are missing or the context cannot be resolved, regenerate them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data
```

---

## 6. Run Unit Tests

If a test project exists in the solution, execute the test suite to verify that core logic in `Bookstore.Domain` and `Bookstore.Data` behaves as expected.

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry forms, to confirm end-to-end functionality.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains the correct configuration values, including connection strings, and that any settings previously stored in `Web.config` or `App.config` have been migrated appropriately.

- `Web.config` is not used in cross-platform .NET; settings should reside in `appsettings.json` or environment variables.
- Verify that `IConfiguration` is used throughout the application to read settings.

---

## 9. Validate Logging

Ensure that logging is configured using `Microsoft.Extensions.Logging` or a compatible provider. Any references to `System.Diagnostics.Trace` or legacy logging frameworks should be reviewed and replaced if necessary.

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify that all required assets, static files, and configuration files are present before deploying to the target environment.