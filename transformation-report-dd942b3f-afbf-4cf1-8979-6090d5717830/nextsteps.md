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

Perform a full solution build to confirm there are no issues beyond what was reported:

```bash
dotnet build --configuration Release
```

Address any warnings that may surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them now:

```bash
dotnet test
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core or another ORM, verify the following:

- Connection strings in `appsettings.json` are correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, etc.) is appropriate for the target platform and database.

---

## 5. Run the Web Application Locally

Start the web application to confirm it runs correctly on the new framework:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and verify core functionality such as page rendering, navigation, and data retrieval.
- Check the console output and application logs for any runtime exceptions or warnings.

---

## 6. Review Configuration Files

- Confirm that `appsettings.json` and `appsettings.Production.json` contain all necessary configuration values that were previously held in `Web.config` or `App.config`.
- Verify that any environment-specific settings (e.g., connection strings, API keys) are correctly configured for each target environment.

---

## 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or dependencies that may not function correctly on Linux or macOS if cross-platform support is a requirement. Common areas to check include:

- File path handling (use `Path.Combine` rather than hardcoded separators).
- Registry access.
- Windows Authentication or IIS-specific middleware.
- Any use of `System.Drawing` which may require additional native dependencies on non-Windows platforms.

---

## 8. Validate Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects to avoid compatibility issues between assemblies.