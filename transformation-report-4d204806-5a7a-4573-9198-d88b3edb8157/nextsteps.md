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

Replace or remove these with cross-platform equivalents where applicable.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Sqlite`).
- Any pending migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a local or development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute all tests to verify functional correctness after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, including any pages or endpoints that interact with `Bookstore.Data` and `Bookstore.Domain`.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains all necessary configuration that may have previously resided in `Web.config` or `App.config`, including:

- Connection strings
- Logging configuration
- Application-specific settings

Legacy `Web.config` transformation behavior is not supported in ASP.NET Core. Ensure environment-specific settings are handled using `appsettings.{Environment}.json` or environment variables.

---

## 9. Validate on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, consider running the application on Linux or macOS to confirm no platform-specific runtime issues exist:

```bash
dotnet run --project Bookstore.Web
```

Address any `PlatformNotSupportedException` or file path issues (e.g., hardcoded backslashes) that surface during this step. Use `Path.Combine` for all file path construction.