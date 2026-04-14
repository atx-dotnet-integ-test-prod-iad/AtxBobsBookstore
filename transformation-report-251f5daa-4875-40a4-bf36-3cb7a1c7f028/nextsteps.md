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

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

- Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.
- Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, confirm that database access is functioning correctly:

- If the project uses **Entity Framework Core**, verify that all migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project was migrated from **Entity Framework 6**, confirm that the switch to **Entity Framework Core** has been handled, as EF Core has API differences that may not surface as build errors but will cause runtime failures.

---

## 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and test primary user flows such as browsing, searching, and any data submission forms.
- Check the console output and application logs for runtime exceptions or warnings.
- Verify that configuration values (connection strings, app settings) have been correctly migrated from `Web.config` to `appsettings.json`.

---

## 6. Review Configuration Migration

Legacy .NET Framework projects use `Web.config` for configuration. Confirm that all relevant settings have been moved to `appsettings.json` or `appsettings.{Environment}.json`:

- Connection strings
- Application-specific settings
- Authentication or authorization configuration
- Any third-party library configuration sections

---

## 7. Check for Platform-Specific API Usage

Cross-platform .NET does not support certain Windows-specific APIs. Run the .NET compatibility analyzer to identify any remaining platform-specific calls:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Alternatively, use the **upgrade assistant** or **API analyzer** to scan for APIs that are unsupported on Linux or macOS if cross-platform deployment is intended.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files, static assets, and configuration files are present before deploying to the target environment.