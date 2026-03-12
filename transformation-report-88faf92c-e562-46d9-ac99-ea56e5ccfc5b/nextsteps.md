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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check NuGet for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, runtime issues can arise from Windows-specific APIs. Search the codebase for usages of:

- `System.Web` (not available in cross-platform .NET)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-only file path assumptions (e.g., hardcoded backslashes)
- `HttpContext` usage patterns specific to ASP.NET (classic)

Replace or abstract any such usages with cross-platform equivalents.

---

## 5. Run the Application Locally

Start the web application and verify it runs correctly on your local machine:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application URL shown in the terminal output and verify:

- The home page loads without errors
- Core features such as browsing, searching, and any data-driven pages function as expected
- No unhandled exceptions appear in the console output

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the database connection string in `appsettings.json` is valid for the target environment. Then apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Verify that the database schema is correct and that basic CRUD operations function as expected.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior:

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral regressions introduced during the migration.

---

## 8. Validate on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, consider running the application on Linux or macOS to confirm there are no platform-specific runtime issues:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Pay attention to file path handling, case sensitivity in file names, and any OS-specific behavior in the application logic.

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.