# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

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

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are present, apply them to a test database to confirm they execute without errors:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the connection string in `appsettings.json` (or `appsettings.Development.json`) is correctly configured for your target environment.

---

## 5. Run the Application Locally

Start the web application locally and verify that it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that:

- Pages load without errors
- Data is read from and written to the database correctly
- Any authentication or authorization flows behave as expected

---

## 6. Review Configuration and Environment Settings

Cross-platform .NET no longer relies on `Web.config` for runtime configuration. Confirm that:

- All configuration values previously in `Web.config` or `App.config` have been moved to `appsettings.json` or environment variables
- Environment-specific settings are handled using `appsettings.{Environment}.json` files
- Any platform-specific paths or file system assumptions in the code have been updated to use `Path.Combine` or equivalent cross-platform APIs

---

## 7. Publish the Application

Once local validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to your target environment.