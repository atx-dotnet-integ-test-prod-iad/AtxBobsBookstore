# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Review the NuGet packages and code in each project for any Windows-specific dependencies that may not function correctly on Linux or macOS. Common areas to check include:

- `System.Drawing.Common` — has platform limitations on non-Windows systems
- Registry access via `Microsoft.Win32`
- Windows Authentication or IIS-specific middleware in `Bookstore.Web`

Replace or conditionally compile any incompatible APIs using cross-platform alternatives.

---

## 5. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that the database provider and connection strings are correctly configured for cross-platform use. If Entity Framework Core is in use, ensure the correct provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).

Run any pending migrations to validate the data layer:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite to verify functional correctness after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally and verify that the application behaves as expected.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify:

- Pages load without errors
- Data is read and written correctly
- Authentication and authorization function as expected
- Static assets are served correctly

---

## 8. Review `appsettings.json` and Configuration

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) are present and correctly structured. Ensure sensitive values such as connection strings are not hardcoded and are managed through environment variables or a secrets manager.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.