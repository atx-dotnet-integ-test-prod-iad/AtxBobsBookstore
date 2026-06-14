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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify that no project still references `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review the dependencies in each project for any packages or APIs that are Windows-only. Common areas to check include:

- **`Bookstore.Data`**: Confirm the database provider (e.g., Entity Framework Core) is configured for cross-platform use. If SQL Server is used, ensure the connection string and provider are compatible.
- **`Bookstore.Web`**: Check for any usage of `System.Web`, OWIN middleware, or other ASP.NET Framework-specific namespaces that do not exist in ASP.NET Core.
- **`Bookstore.Domain`**: Verify no domain logic relies on Windows-specific registry, COM interop, or similar platform-bound APIs.

---

## 5. Run Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, verify that existing migrations are compatible with the new setup:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

If the migrations need to be updated or recreated, run:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data
dotnet ef database update --project app/Bookstore.Data
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting `Bookstore.Domain` and `Bookstore.Data` as a baseline for regression coverage.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Check the following manually:

- Application starts without runtime exceptions.
- All pages and routes load as expected.
- Database connectivity is functional.
- Authentication and authorization (if present) behave correctly.

---

## 8. Validate Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are present and correctly configured. Legacy `Web.config` or `App.config` values should have been migrated to the appropriate `appsettings.json` structure. Confirm that:

- Connection strings are present and correct.
- Any application settings previously in `<appSettings>` have been moved to the appropriate JSON configuration keys.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web -c Release -o ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web -c Release -r linux-x64 --self-contained true -o ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.