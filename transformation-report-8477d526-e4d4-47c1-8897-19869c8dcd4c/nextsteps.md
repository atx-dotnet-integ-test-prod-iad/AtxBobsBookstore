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

Run a NuGet package restore to confirm all dependencies resolve correctly against the new target framework.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or missing packages.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, deprecated APIs, or platform compatibility.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether the failure is due to a migration-related behavioral change or a pre-existing issue.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`, etc.).
- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Run any pending Entity Framework Core migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, verify that the model and `DbContext` are intact:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the application locally to verify runtime behavior.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and confirm core functionality works as expected.
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that middleware, routing, authentication, and static files are functioning correctly.

---

## 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` and environment variables rather than `Web.config`. Confirm the following:

- All necessary configuration values (connection strings, API keys, application settings) have been migrated from `Web.config` or `App.config` to `appsettings.json`.
- Environment-specific overrides are in place using `appsettings.Development.json` or `appsettings.Production.json` as appropriate.

---

## 7. Check for Platform-Specific API Usage

Even without build errors, some APIs may have changed behavior on cross-platform .NET. Review the codebase for:

- Use of `System.Web` types that may have been shimmed or replaced.
- File path handling — ensure `Path.Combine` is used rather than hardcoded separators.
- Any Windows-specific registry, COM interop, or WCF dependencies that may not function on non-Windows hosts.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.