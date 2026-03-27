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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether the failure is due to the migration or a pre-existing issue.

If no test projects exist, consider writing basic unit tests for the core logic in `Bookstore.Domain` and `Bookstore.Data` to establish a baseline of confidence.

---

## 4. Verify Entity Framework Core Migrations (If Applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that your database migrations are intact and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or the schema has changed, generate a new migration:

```bash
dotnet ef migrations add PostMigrationValidation --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations to a test database before touching any production data:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and verify it runs correctly on the local development environment:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify the following:

- All pages load without errors.
- Data is read from and written to the database correctly.
- Any authentication or authorization flows behave as expected.
- Static assets (CSS, JavaScript, images) are served correctly.

---

## 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings in `appsettings.json` are correct for the target environment.
- Any environment-specific settings are placed in `appsettings.Production.json`.
- Secrets such as API keys or passwords are not stored in source-controlled configuration files. Use the .NET Secret Manager for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your_connection_string"
```

---

## 7. Check for Platform-Specific Code

Even without build errors, certain APIs behave differently or are unavailable on non-Windows platforms. Review the codebase for usage of the following and test on the intended target platform:

- `System.Drawing` (GDI+ is not fully supported on Linux/macOS without additional packages)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- COM interop

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present, including configuration files and static assets.