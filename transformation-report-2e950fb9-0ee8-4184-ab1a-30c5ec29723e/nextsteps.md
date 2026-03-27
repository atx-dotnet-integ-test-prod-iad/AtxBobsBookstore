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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages are flagged, update them using:

```bash
dotnet add <project> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining Windows-specific APIs or packages, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- COM interop

These will not function on Linux or macOS. Replace them with cross-platform equivalents where applicable.

---

## 5. Validate the Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is compatible with the target framework.
- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Run any pending Entity Framework Core migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL shown in the console output and confirm the core functionality works as expected, including:

- Page rendering
- Database read and write operations
- Authentication and authorization, if applicable

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may indicate behavioral regressions introduced during the migration.

---

## 8. Review Logging and Configuration

Confirm that the application's configuration system has been fully migrated from `Web.config` or `App.config` to `appsettings.json` and the `Microsoft.Extensions.Configuration` pattern. Check that:

- All connection strings are present in `appsettings.json`
- Environment-specific overrides use `appsettings.{Environment}.json`
- Logging is configured via `Microsoft.Extensions.Logging` rather than a legacy provider

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.