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

Even without build errors, certain APIs used in the original project may only function correctly on Windows. Run the .NET Compatibility Analyzer to surface any platform-specific concerns.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Pay particular attention to any usage of `System.Web`, `System.Drawing`, or Windows Registry APIs within `Bookstore.Data` and `Bookstore.Web`.

---

## 5. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct version is referenced. Entity Framework Core is required for cross-platform compatibility. Check that:

- The EF Core provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is present.
- Any migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as they may indicate behavioral differences between .NET Framework and modern .NET.

---

## 7. Run the Application Locally

Start the `Bookstore.Web` project locally and verify that core functionality works as expected.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually test the following areas:

- Application startup and routing
- Database connectivity and data retrieval
- Any authentication or session management features
- Static file serving (CSS, JavaScript, images)

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration values that were previously held in `web.config` or `app.config`. Confirm that:

- Connection strings are correctly defined under `"ConnectionStrings"`.
- Any application settings have been moved to the appropriate `appsettings.json` section.
- Environment-specific overrides exist in `appsettings.Development.json` or `appsettings.Production.json` as needed.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.