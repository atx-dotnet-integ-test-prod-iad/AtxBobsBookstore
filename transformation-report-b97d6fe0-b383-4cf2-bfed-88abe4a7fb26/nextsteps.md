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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check NuGet for updated versions compatible with your target .NET version.

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

Ensure all three projects target the same framework version to avoid compatibility issues between them.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding.

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Connection strings in `appsettings.json` are accurate for the target environment.
- Run any pending migrations to confirm the database schema is up to date.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Web Application Locally

Start the web application to verify it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL printed in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify that the core pages and features load without errors.

---

## 7. Check for Windows-Specific APIs

Even when a build succeeds, there may be runtime issues caused by Windows-specific APIs that are not available on Linux or macOS. Search the codebase for usages of:

- `Microsoft.Win32`
- `System.Windows.Forms`
- `System.Drawing` (GDI+ based)
- Registry access
- Windows file path assumptions (e.g., hardcoded backslashes)

Replace or abstract any such usages with cross-platform alternatives where applicable.

---

## 8. Review Configuration and Secrets

Confirm that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Sensitive values such as connection strings or API keys should be managed using the .NET Secret Manager for local development.

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.