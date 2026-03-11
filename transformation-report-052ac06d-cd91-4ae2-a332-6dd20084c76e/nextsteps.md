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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check NuGet for cross-platform compatible versions.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- Connection strings and application settings have been moved to `appsettings.json`.
- Environment-specific overrides exist in `appsettings.Development.json` or `appsettings.Production.json` as needed.
- Any configuration previously handled by `System.Configuration.ConfigurationManager` has been replaced with `Microsoft.Extensions.Configuration`.

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is in use, verify it has been migrated to **Entity Framework Core**.
- Run any pending migrations to ensure the database schema is up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the `DbContext` is registered correctly in `Program.cs` or `Startup.cs` using `AddDbContext`.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration issues or pre-existing problems.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and verify core functionality such as browsing, searching, and any authentication flows.
- Check the console output and application logs for runtime exceptions or middleware configuration issues.
- Confirm that static files, routing, and middleware are functioning as expected under the new `WebApplication` builder pattern if `Program.cs` was updated.

---

## 7. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that may not be supported on Linux or macOS if cross-platform deployment is intended.

Common areas to check:

- Use of `Microsoft.Win32` or Windows Registry access.
- Windows-specific file path separators (use `Path.Combine` instead of hardcoded `\`).
- Any P/Invoke calls or native Windows libraries.

Use the .NET Compatibility Analyzer to assist with this:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.