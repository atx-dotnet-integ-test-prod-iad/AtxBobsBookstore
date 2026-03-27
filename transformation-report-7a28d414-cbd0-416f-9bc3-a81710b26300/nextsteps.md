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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for compatible versions targeting the current .NET runtime.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

- Review all test results carefully.
- Pay particular attention to any tests that interact with the database layer (`Bookstore.Data`) or the web layer (`Bookstore.Web`), as these are the most likely areas to surface runtime behavioral differences after migration.
- If no test projects currently exist, consider writing basic smoke tests for critical domain logic in `Bookstore.Domain` and data access operations in `Bookstore.Data`.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, managing inventory).
- Check the console output and application logs for any unhandled exceptions or warnings.
- Verify that all connection strings and configuration values in `appsettings.json` are correct for the target environment.

---

## 6. Review Configuration Files

Confirm that the following have been correctly migrated from any legacy configuration formats (e.g., `Web.config`, `App.config`) to the modern `appsettings.json` pattern:

- Database connection strings
- Application-specific settings
- Logging configuration
- Any environment-specific overrides (`appsettings.Development.json`, `appsettings.Production.json`)

---

## 7. Validate Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file and verifying the `<TargetFramework>` element. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web`.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a folder for deployment:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files and dependencies are present before deploying to the target environment.