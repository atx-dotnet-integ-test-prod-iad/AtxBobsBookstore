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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no project is still referencing `net48` or any other .NET Framework moniker unless intentionally targeting multiple frameworks.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project is using `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity`. Verify database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are present and up to date.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC project targeting .NET Framework, confirm it has been migrated to ASP.NET Core. Check that middleware configuration in `Program.cs` or `Startup.cs` is correct, and that any `System.Web` references have been fully replaced.
- **`Bookstore.Domain`**: Check for any use of `AppDomain`, `ConfigurationManager`, or other APIs that are either absent or behave differently on cross-platform .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or unit tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before proceeding.

---

## 6. Validate Application Configuration

- Confirm that `appsettings.json` (and `appsettings.Development.json`) contain the correct connection strings and application settings, replacing any values that were previously in `Web.config` or `App.config`.
- Verify that configuration is being read correctly at runtime using `IConfiguration` in ASP.NET Core.

---

## 7. Run the Application Locally

Start the application locally and perform manual smoke testing of core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Test the following areas at a minimum:

- Application startup with no exceptions
- Database connectivity (if applicable)
- Core page rendering and navigation in `Bookstore.Web`
- Any data read/write operations tied to `Bookstore.Data`

---

## 8. Verify Cross-Platform Behavior (Optional but Recommended)

If one of the goals of this migration is to run on non-Windows operating systems, run the application on Linux or macOS to confirm there are no platform-specific issues such as:

- File path separators (use `Path.Combine` rather than hardcoded `\` separators)
- Case-sensitive file or directory references
- Windows-only libraries or COM interop dependencies

---

## 9. Review Publish Output

Before deploying, publish the application and review the output for any issues.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, static assets, and configuration files are present.