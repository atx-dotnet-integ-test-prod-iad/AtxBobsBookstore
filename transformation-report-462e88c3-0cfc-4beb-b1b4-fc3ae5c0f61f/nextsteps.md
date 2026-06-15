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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

---

## 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, verify that the data layer is functioning correctly:

- Confirm that the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- If the project uses migrations, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and test core functionality such as browsing, searching, and any data-driven pages.
- Check the console output for any runtime exceptions or middleware configuration errors.
- Verify that configuration values (connection strings, app settings) in `appsettings.json` are correct and that no values are still referencing legacy `Web.config` entries.

---

## 6. Review Configuration Migration

Confirm that all configuration previously held in `Web.config` or `App.config` has been properly moved to `appsettings.json` or environment-specific configuration files such as `appsettings.Development.json`. Pay particular attention to:

- Database connection strings
- Authentication settings
- Any custom application settings keys

---

## 7. Check for Platform-Specific API Usage

Run the .NET compatibility analyzer to identify any remaining platform-specific API calls that may not behave consistently across operating systems:

```bash
dotnet build /p:EnableNETAnalyzers=true --configuration Release
```

Address any reported diagnostics related to platform compatibility before deploying to a non-Windows environment.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and configuration files are present before deploying to the target environment.