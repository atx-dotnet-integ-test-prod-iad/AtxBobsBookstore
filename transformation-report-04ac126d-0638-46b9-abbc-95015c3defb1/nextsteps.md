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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, it is worth adding tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely depends on Entity Framework or another data access technology, verify the following:

- **Connection strings** in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target database.
- If Entity Framework Core is in use, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify the following:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Any authentication or authorization flows behave as expected.

Check the console output and application logs for any runtime exceptions or warnings.

---

## 6. Review Target Framework

Confirm that all three projects are targeting the intended .NET version. Open each `.csproj` file and verify the `<TargetFramework>` element reflects the desired version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects to avoid cross-framework compatibility issues.

---

## 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Manually review the following areas for any code that may compile but behave differently at runtime:

- `System.Web` references — these are not available in .NET Core or later.
- `HttpContext` usage — ensure it is accessed via dependency injection rather than `HttpContext.Current`.
- `ConfigurationManager` — this should be replaced with `IConfiguration` from `Microsoft.Extensions.Configuration`.
- `App.config` or `Web.config` — configuration should now be handled through `appsettings.json`.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all necessary files, including static assets and configuration files, are present before deploying to the target environment.