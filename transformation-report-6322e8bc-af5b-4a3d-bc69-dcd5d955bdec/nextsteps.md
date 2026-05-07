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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- Any Entity Framework Core migrations are up to date. Run the following to check the current migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add PostMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate Configuration Files

Review `appsettings.json` and `appsettings.Production.json` in `Bookstore.Web` to confirm the following:

- Connection strings are correct and point to the intended database.
- Any configuration keys that were previously stored in `Web.config` have been properly moved to the new `appsettings.json` format.
- Environment-specific settings are separated appropriately using environment-based configuration files.

---

## 6. Run the Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that core features such as browsing, data retrieval, and any form submissions function correctly.

---

## 7. Review Target Framework

Open each `.csproj` file and confirm that the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-framework compatibility issues.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.