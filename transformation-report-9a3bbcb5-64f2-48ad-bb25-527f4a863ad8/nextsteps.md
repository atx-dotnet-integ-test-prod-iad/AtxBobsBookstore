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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated packages or version conflicts. If any packages were targeting the old .NET Framework, check that their cross-platform equivalents are in use.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- If the original project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to the appropriate `appsettings.json` sections.
- Check that any environment-specific configuration (e.g., database connection strings) is correctly set for your target environment.

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` for SQL Server).
- Any migrations that existed in the original project are still present and valid.
- Run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied to a database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether they are failing due to migration issues or pre-existing defects.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and verify that core functionality (e.g., browsing books, user interactions, data persistence) works as expected.
- Check the console output and application logs for any runtime exceptions or misconfigurations.

---

## 7. Check for Platform-Specific Code

Even without build errors, there may be runtime issues caused by APIs that behaved differently on .NET Framework. Pay attention to:

- File path handling — use `Path.Combine` rather than hardcoded backslashes.
- Any use of `System.Web` namespaces that may have been replaced with ASP.NET Core equivalents.
- Windows-specific registry or COM interop calls that will not function on Linux or macOS.

---

## 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, review the `Program.cs` (and `Startup.cs` if present) to confirm:

- Middleware is registered in the correct order (e.g., authentication before authorization).
- Static files, routing, and session configuration are correctly set up for ASP.NET Core.
- Any HTTP modules or HTTP handlers from the original project have been replaced with the appropriate ASP.NET Core middleware.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present before deploying to the target environment.