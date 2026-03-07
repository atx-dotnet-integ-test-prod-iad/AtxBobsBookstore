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

Ensure the output shows `Build succeeded` with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). For example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may still reference Windows-specific APIs that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these issues:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to `Bookstore.Data` if it uses any file system paths, registry access, or Windows-specific libraries.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality is preserved:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test projects currently exist, consider writing basic integration tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- The database can be reached and updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output and manually verify that key pages and features load without errors. Check the console and application logs for any runtime exceptions.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) contain valid configuration for the current environment. If the legacy project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to the appropriate `appsettings.json` entries or environment variables.

---

## 9. Test on a Non-Windows Platform (If Applicable)

If cross-platform support is a goal, run the application on a Linux or macOS machine (or WSL2 on Windows) to surface any remaining platform-specific runtime issues:

```bash
dotnet run --project Bookstore.Web
```

Address any `PlatformNotSupportedException` or similar runtime errors that appear.