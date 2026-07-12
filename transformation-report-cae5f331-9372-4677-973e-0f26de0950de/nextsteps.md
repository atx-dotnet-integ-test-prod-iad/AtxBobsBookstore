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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Review `Bookstore.Data` and `Bookstore.Web` for any remaining dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

These will not function on Linux or macOS and will require replacement or removal.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql` for PostgreSQL).
- Any pending migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --verbosity normal
```

Address any test failures before proceeding. Pay particular attention to tests covering `Bookstore.Domain` entities and `Bookstore.Data` repository logic.

---

## 7. Run the Web Application Locally

Start the application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser.
- Verify that database connectivity is functioning.
- Check application logs for runtime exceptions or deprecation warnings.

---

## 8. Review Configuration Files

Ensure `appsettings.json` (and `appsettings.Development.json`) are properly configured for the new hosting model. Confirm that:

- Connection strings are correct.
- Any configuration previously stored in `Web.config` has been migrated to `appsettings.json`.
- Environment-specific settings are handled using the `ASPNETCORE_ENVIRONMENT` variable.

---

## 9. Validate on Target Operating Systems

If cross-platform support is a goal, test the application on each intended operating system (Windows, Linux, macOS) to surface any platform-specific runtime issues that would not appear during compilation.