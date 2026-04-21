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

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs or nullable reference types, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

If no test project currently exists, it is worth creating one to cover core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`. This is especially important after a migration to catch any behavioral differences introduced by the new runtime.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, the project likely uses Entity Framework Core or a similar data access library. Confirm the following:

- The connection string in `appsettings.json` (or equivalent) points to the correct database instance.
- If Entity Framework Core is used, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Any authentication or authorization flows function as expected.

---

## 6. Review Configuration Files

Cross-platform .NET no longer relies on `Web.config` for runtime configuration. Confirm the following:

- All configuration values previously in `Web.config` or `App.config` have been moved to `appsettings.json` or environment variables.
- Connection strings, API keys, and environment-specific settings are correctly defined.
- The `ASPNETCORE_ENVIRONMENT` environment variable is set appropriately (`Development`, `Staging`, or `Production`).

---

## 7. Review Static Files and wwwroot

Confirm that all static assets (CSS, JavaScript, images) are located under the `wwwroot` folder in `Bookstore.Web`. In cross-platform .NET, static files must be served from this directory by default.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element references a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm the targeted version is still within its support window.