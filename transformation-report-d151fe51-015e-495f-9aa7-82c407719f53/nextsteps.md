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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether the failure is due to the migration or a pre-existing issue.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- The connection string in your configuration file (`appsettings.json`) is correct and points to the appropriate database.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without runtime exceptions.
- Core pages and routes load correctly.
- Database read and write operations function as expected.
- Any authentication or authorization flows work correctly.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application settings. Confirm that:

- All settings previously in `Web.config` or `App.config` have been moved to `appsettings.json`.
- Environment-specific settings are handled using `appsettings.{Environment}.json` where appropriate.
- Any connection strings, API keys, or environment variables are correctly configured for the target environment.

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that were available in .NET Framework but may behave differently or require alternatives in cross-platform .NET:

- `System.Web` references should have been removed or replaced.
- Any Windows-specific APIs (e.g., registry access, Windows Authentication) should be reviewed if the target deployment environment is non-Windows.

---

## 8. Publish the Application

Once local validation is complete, publish the application to the target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files, including static assets and configuration files, are present before deploying to the target server.