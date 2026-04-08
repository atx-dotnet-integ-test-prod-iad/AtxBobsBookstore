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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify that no project is still referencing `net48` or any other .NET Framework moniker unintentionally.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any NuGet packages or APIs that are Windows-only. Common examples include:

- `Microsoft.Win32` registry APIs
- `System.Drawing.Common` (requires additional configuration on Linux/macOS)
- Any COM interop references

If any are found, evaluate whether a cross-platform alternative exists or whether a runtime guard (`OperatingSystem.IsWindows()`) is appropriate.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate core logic:

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral differences introduced by the migration.

---

## 6. Validate Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql` for PostgreSQL).
- Run any pending migrations against a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Verify that the database schema matches expectations after the migration runs.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without runtime exceptions.
- All routes respond as expected.
- Static assets load correctly.
- Any authentication or session behavior works as intended.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` and `appsettings.{Environment}.json` contain the correct configuration values, particularly:

- Database connection strings
- Any API keys or service endpoints previously stored in `Web.config`

Note that `Web.config` is no longer the primary configuration mechanism in cross-platform .NET. Confirm all necessary values have been moved to `appsettings.json` or environment variables.

---

## 9. Test on Target Platform

If the goal is to run on Linux or macOS, perform a test run on that operating system to surface any remaining platform-specific issues that may not appear on Windows.

---

## 10. Publish the Application

Once all validation steps pass, publish the application:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.