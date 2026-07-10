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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project still references `net48` or any other Windows-only framework moniker unless intentionally targeting Windows.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining dependencies that are Windows-specific, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry APIs
- COM interop references

These will not function correctly on Linux or macOS and will require replacement or removal.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality has not regressed.

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral differences introduced by the migration.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another ORM, verify the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`) is compatible with the target .NET version.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs as expected.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and confirm that:

- Pages load without errors.
- Data access operations (reads and writes) function correctly.
- Authentication and authorization behave as expected, if applicable.

---

## 8. Review Configuration and Middleware

If the project was migrated from ASP.NET (Framework) to ASP.NET Core, confirm the following have been properly migrated:

- `Global.asax` logic has been moved to `Program.cs` or `Startup.cs`.
- `Web.config` settings have been moved to `appsettings.json`.
- HTTP modules and handlers have been replaced with ASP.NET Core middleware.
- Static file serving is configured via `UseStaticFiles()`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present before deploying to the target environment.