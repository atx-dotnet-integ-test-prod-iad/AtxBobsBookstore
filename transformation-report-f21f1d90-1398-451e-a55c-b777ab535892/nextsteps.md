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

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may contain Windows-specific APIs that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these issues.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to:
- `System.Web` references (not available in cross-platform .NET)
- Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions

---

## 5. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that the data access technology in use is compatible with cross-platform .NET.

- If using **Entity Framework 6**, migrate to **Entity Framework Core**.
- Confirm the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, or `Sqlite`) is referenced and up to date.
- Run any pending migrations or verify the database schema is in sync:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate runtime behavior.

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing basic smoke tests for the domain logic in `Bookstore.Domain` and the data access methods in `Bookstore.Data`.

---

## 7. Run the Application Locally

Start the web application and verify it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at runtime:
- Application starts without exceptions
- Database connections are established successfully
- Core application routes and pages load as expected
- Any authentication or session-based functionality behaves correctly

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains the appropriate configuration that was previously held in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Logging configuration
- Application-specific settings

Legacy `Web.config` transforms are not used in cross-platform .NET. All environment-specific configuration should use `appsettings.{Environment}.json` or environment variables.

---

## 9. Validate Static Assets and Razor Views

If `Bookstore.Web` uses Razor Pages or MVC Views, manually navigate through the application to confirm:
- Views render without runtime errors
- Static files (CSS, JavaScript, images) are served correctly
- Bundling and minification, if used, functions as expected (note that `System.Web.Optimization` is not available; consider `WebOptimizer` or similar alternatives)

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, views, and assets are present before deploying to the target environment.