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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`). For example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a specific requirement for it.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, some NuGet packages or APIs may only function correctly on Windows. Review the dependencies in each project for any of the following:

- Packages that reference `Microsoft.Win32` namespaces
- Any usage of `System.Web` (not supported in cross-platform .NET)
- Registry access or Windows-specific file path assumptions

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific calls if needed.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core business logic in `Bookstore.Domain` and data access behavior in `Bookstore.Data`.

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting the `Bookstore.Domain` project at minimum, as it is the most independent layer.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Connection strings in `appsettings.json` are correct for the target environment.
- Run any pending migrations to confirm the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and confirm the application loads and functions as expected, including any data-driven pages that rely on `Bookstore.Data` and `Bookstore.Domain`.

---

## 8. Test on a Non-Windows Platform (If Cross-Platform Is Required)

If one of the goals of the migration is to support Linux or macOS, run the application on the target platform and verify behavior is consistent. Pay particular attention to:

- File path separators (`/` vs `\`)
- Case sensitivity in file and directory names
- Any environment-specific configuration values

---

## 9. Review and Update `appsettings.json`

Confirm that `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`) contain the correct configuration values for the target deployment environment, including connection strings, logging levels, and any application-specific settings.