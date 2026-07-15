# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. Address any that appear by updating the relevant `<PackageReference>` entries in the `.csproj` files.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining dependencies or APIs that are Windows-only. Common areas to check include:

- Use of `Microsoft.Win32` or `System.Windows` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslashes, drive letters)
- Any remaining references to `System.Web`

Use the .NET Upgrade Assistant compatibility analyzer or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist with this.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Steps to validate:

- Confirm the application starts without runtime exceptions
- Navigate through the primary pages and features
- Verify that database connectivity works as expected (check connection strings in `appsettings.json`)
- Confirm that any authentication or authorization flows function correctly

---

## 7. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) are correctly configured. Specifically:

- Connection strings should not contain Windows-only paths or integrated security settings that are incompatible with the target deployment OS
- Any file system paths should use `Path.Combine` or forward-slash notation for cross-platform compatibility

---

## 8. Verify Database Migrations

If the project uses Entity Framework Core, confirm that all migrations are up to date and apply cleanly.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj

dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project was previously using Entity Framework 6 (EF6), confirm it has been migrated to Entity Framework Core, as EF6 does not support cross-platform .NET.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.