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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If test projects exist within the solution, execute them to verify that business logic and data access behavior remain intact after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Pay close attention to any tests that interact with the database layer (`Bookstore.Data`) or domain logic (`Bookstore.Domain`), as these are the most likely areas to surface behavioral regressions.

---

## 4. Verify Database Connectivity and Migrations

If the project uses Entity Framework Core, confirm that your migrations are up to date and that the database connection string is correctly configured for the target environment.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are pending, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Ensure the connection string in `appsettings.json` or environment-specific configuration files points to the correct database instance.

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation of core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following at a minimum:

- The application starts without runtime exceptions.
- Key pages and routes load correctly.
- Data is read from and written to the database as expected.
- Any authentication or authorization flows behave correctly.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently than .NET Framework in some cases. Review the following:

- Confirm `appsettings.json` and `appsettings.{Environment}.json` contain all required settings previously held in `Web.config` or `App.config`.
- Verify that any file paths used in the application use `Path.Combine` or forward-slash-safe patterns to ensure cross-platform compatibility.
- Check that environment variables or secrets previously stored in `Web.config` have been migrated to the appropriate .NET configuration provider.

---

## 7. Check for Platform-Specific API Usage

Even without build errors, there may be runtime issues caused by APIs that are not fully supported on all platforms. Run the .NET Compatibility Analyzer if it has not already been applied:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any reported diagnostics and replace platform-specific calls with cross-platform alternatives where applicable.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and configuration files are present.