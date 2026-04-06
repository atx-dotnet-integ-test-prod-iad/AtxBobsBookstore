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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention after migration.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid interoperability issues.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for any APIs or packages that are Windows-only, such as:

- `Microsoft.Win32` namespace usage
- `System.Drawing` (requires additional packages on Linux/macOS)
- Any COM interop or registry access

If found, replace these with cross-platform alternatives or add appropriate runtime guards.

---

## 5. Database and Entity Framework Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- The EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`)
- Any pending migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains test projects, execute them to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows.
- Check the console output and application logs for runtime exceptions or configuration errors.
- Verify that connection strings and other configuration values in `appsettings.json` are correct for the target environment.

---

## 8. Validate Configuration and Secrets

Review `appsettings.json` and `appsettings.Production.json` to confirm:

- Connection strings point to the correct database instances.
- Any API keys or secrets have been migrated away from `web.config` and are stored using the .NET configuration system or `dotnet user-secrets` for local development.

---

## 9. Cross-Platform Smoke Test

If cross-platform support is a goal, run the application on each target operating system (Windows, Linux, macOS) to identify any platform-specific runtime issues that do not surface at compile time.