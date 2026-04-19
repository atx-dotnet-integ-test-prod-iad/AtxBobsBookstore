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

Review the output for any warnings about deprecated or unlisted packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or target framework compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or another legacy framework, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Inspect the `Bookstore.Data` and `Bookstore.Web` projects for any remaining Windows-specific dependencies, such as:

- `System.Web` references
- Windows Registry access
- `HttpContext` usage from `System.Web` rather than `Microsoft.AspNetCore.Http`
- Any P/Invoke calls targeting Windows-only APIs

Replace or remove these as needed to ensure true cross-platform compatibility.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Any pending migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

- Apply migrations to a test database:

```bash
dotnet ef database update --project app/Bookstore.Data
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to verify that the migrated code behaves as expected.

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral differences introduced by the migration.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally and verify that the application loads and functions correctly.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Manually test the following areas:

- Application startup with no unhandled exceptions
- Database connectivity and data retrieval
- All major routes and pages render correctly
- Authentication and authorization flows, if applicable

---

## 8. Verify Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) are present and correctly configured for the new hosting model. Legacy `Web.config` or `App.config` settings should have been migrated to `appsettings.json`. Verify connection strings, logging configuration, and any application-specific settings are accurate.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, then deploy the output to your target hosting environment.