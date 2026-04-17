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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If test projects exist in the solution, execute them to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release
```

Review the test output for any failures. Pay close attention to tests that cover:

- Data access logic in `Bookstore.Data`
- Domain model behavior in `Bookstore.Domain`
- HTTP request handling and middleware in `Bookstore.Web`

---

## 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas:

- Application startup completes without exceptions
- Database connections are established correctly (review connection strings in `appsettings.json`)
- Core pages and endpoints return expected responses
- Any authentication or authorization flows work as intended

---

## 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm that:

- All connection strings have been migrated to `appsettings.json`
- Environment-specific settings are handled using `appsettings.Development.json` and `appsettings.Production.json`
- Any configuration keys previously read via `ConfigurationManager` are now accessed through `IConfiguration`

---

## 6. Validate Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`)
- Migrations are present and up to date

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply any pending migrations against the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Check for Platform-Specific API Usage

Even when a project builds successfully, it may reference APIs that are not fully supported on all target platforms. Run the .NET compatibility analyzer or review warnings in the build output for any `CA1416` platform compatibility warnings.

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present.