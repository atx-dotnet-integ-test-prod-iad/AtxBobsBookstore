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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless explicitly required.

---

## 4. Check for Windows-Specific Dependencies

Review all NuGet package references across the three projects for any packages that are Windows-only. Common examples include:

- `System.Drawing.Common` (requires additional configuration on Linux/macOS post-.NET 6)
- `Microsoft.Win32.*` namespaces
- Any COM interop references

If any are found, replace them with cross-platform alternatives or apply runtime platform guards where necessary.

---

## 5. Database Migration Validation (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that any existing migrations are compatible with the new framework version:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the migrations list is returned without errors, apply them to a local development database to confirm schema integrity:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected:

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral differences introduced by the framework migration.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally and verify that the application loads and functions correctly:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually test the following areas at a minimum:

- Application startup and home page rendering
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Form submissions and data writes

---

## 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) have been correctly migrated from any legacy `Web.config` or `App.config` files. Pay particular attention to:

- Connection strings
- Logging configuration
- Any custom application settings

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, static files, and configuration files are present before deploying to the target environment.