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

Inspect `Bookstore.Data` and `Bookstore.Web` for any remaining dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop components
- `Microsoft.Web.Infrastructure`

These will not function on Linux or macOS and must be replaced with cross-platform equivalents.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
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

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project exists, consider manually exercising the core domain logic in `Bookstore.Domain` to verify business rules behave as expected after migration.

---

## 7. Run the Web Application Locally

Start the web application to confirm it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the URL shown in the console output.
- Test core user-facing functionality such as browsing, searching, and any data entry forms.
- Check the application logs for runtime exceptions or middleware configuration issues.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) contain the correct configuration values. Legacy `Web.config` or `App.config` entries are not used by .NET and must be migrated to `appsettings.json` or environment variables if they have not been already.

---

## 9. Validate on a Non-Windows Platform (Optional but Recommended)

Since the goal of the migration is cross-platform support, run the application on Linux or macOS if possible, and confirm there are no platform-specific runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Address any `PlatformNotSupportedException` or file path separator issues that surface during this step.