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
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target a consistent framework version to avoid interoperability issues.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for any APIs or packages that are Windows-only, as these would not have caused build errors but could cause runtime failures on non-Windows platforms. Common areas to check include:

- Use of `Microsoft.Win32` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- Any remaining references to `System.Web`

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality behaves correctly after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they indicate a regression introduced during migration or a pre-existing issue.

---

## 6. Run the Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically validate:

- Application startup with no runtime exceptions
- Database connectivity from `Bookstore.Data`
- Domain logic behavior from `Bookstore.Domain`
- All primary user-facing routes and pages load correctly

---

## 7. Validate Database Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date and apply correctly against the target database:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

If the project was previously using Entity Framework 6 (classic), verify that the migration to EF Core was handled correctly, as there are breaking differences between the two.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) are present and correctly configured. Legacy projects often stored configuration in `Web.config`, which is not used in cross-platform .NET. Ensure all connection strings and application settings have been moved appropriately.

---

## 9. Test on Target Platform

If the goal is to run the application on a non-Windows operating system, execute the above validation steps on that platform (e.g., Linux or macOS) to surface any platform-specific runtime issues that would not appear on Windows.