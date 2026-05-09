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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project exists, consider writing basic unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Run any pending migrations to ensure the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and check for the following:

- Pages load without HTTP 500 errors.
- Data is read from and written to the database correctly.
- Authentication and authorization flows work as expected, if applicable.
- Static assets (CSS, JavaScript, images) are served correctly.

---

## 6. Review Configuration Files

Confirm that the following configuration concerns have been addressed:

- `Web.config` entries from the legacy project have been migrated to `appsettings.json` or `appsettings.{Environment}.json` where applicable.
- Any `<appSettings>` or `<connectionStrings>` values are now represented using the `Microsoft.Extensions.Configuration` pattern.
- Environment-specific settings are separated by environment name (e.g., `appsettings.Development.json`, `appsettings.Production.json`).

---

## 7. Check for Platform-Specific API Usage

Run the .NET Compatibility Analyzer to detect any remaining usage of Windows-only or platform-specific APIs:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Review any `CA1416` platform compatibility warnings and replace or conditionally compile any APIs that are not supported cross-platform.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and static assets are present before deploying to the target environment.