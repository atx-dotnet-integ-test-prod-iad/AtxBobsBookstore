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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

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

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types or obsolete APIs, as these may indicate areas that need attention even if the build succeeds.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to confirm existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, the project likely uses Entity Framework Core or a similar ORM. Confirm the following:

- The connection string in `appsettings.json` (or `appsettings.Development.json`) points to a valid and accessible database instance.
- If Entity Framework Core is used, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Then apply the migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and verify that:

- Pages load without errors.
- Data is retrieved and displayed correctly from the database.
- Any forms or user interactions function as expected.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently from legacy .NET Framework projects. Confirm the following in `Bookstore.Web`:

- `appsettings.json` contains all necessary configuration values that were previously in `Web.config` or `App.config`.
- Environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate.
- Any connection strings, API keys, or environment-specific values are not hardcoded and are managed through configuration or environment variables.

---

## 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or dependencies that may cause issues when running on Linux or macOS:

- Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file paths using backslashes
- COM interop or Windows-only NuGet packages

Replace any such code with cross-platform equivalents where necessary.

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.