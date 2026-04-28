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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) exist in `Bookstore.Web` and contain the correct connection strings and application settings that were previously in `Web.config` or `App.config`.
- Verify that any environment-specific configuration values are correctly mapped.
- Check that the `Bookstore.Data` project has the correct connection string configuration for Entity Framework or whichever data access layer is in use.

---

## 4. Run Database Migrations

If the project uses Entity Framework Core, verify that migrations are in place and apply them to the target database.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are present and up to date, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If the project was previously using Entity Framework 6, confirm that it has been migrated to Entity Framework Core, as EF6 does not have full support on cross-platform .NET.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to verify that business logic and data access behavior remain consistent after the migration.

```bash
dotnet test
```

Review any failing tests and determine whether failures are caused by behavioral differences introduced by the migration or by pre-existing issues.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web
```

Verify the following:
- The application starts without runtime exceptions.
- Routing and page rendering work as expected.
- Database read and write operations function correctly.
- Any authentication or authorization mechanisms behave as intended.

---

## 7. Check for Windows-Specific API Usage

Even though the build succeeds, runtime issues can arise from Windows-specific APIs that are not available on Linux or macOS. Use the .NET Compatibility Analyzer or review the code manually for usage of:

- `Microsoft.Win32` namespace
- Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- COM interop

If cross-platform deployment is a goal, these areas will need to be addressed.

---

## 8. Publish the Application

Once validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files, static assets, and configuration files are present.