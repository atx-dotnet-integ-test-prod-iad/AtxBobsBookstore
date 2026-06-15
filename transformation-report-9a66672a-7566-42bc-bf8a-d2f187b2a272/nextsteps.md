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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention after migration.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid `net48` or any `netstandard` targets if full cross-platform support is required.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for any APIs or packages that are Windows-only, such as:

- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., backslashes)
- COM interop or P/Invoke calls targeting Windows DLLs

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review test results for any failures that may have been introduced by the migration. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Connection strings in `appsettings.json` are correct for the target environment.
- Pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application to confirm it runs correctly on the new runtime:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry features, to confirm end-to-end functionality.

---

## 8. Review Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) to confirm:

- Middleware is registered using the current .NET conventions.
- Any legacy `Startup.cs` patterns have been consolidated into the `Program.cs` minimal hosting model if targeting .NET 6 or later.
- Authentication, authorization, and session configuration are functioning as expected.

---

## 9. Test on a Non-Windows Environment (If Required)

If cross-platform support is a goal, run the application on Linux or macOS to confirm there are no runtime issues that did not surface during the build:

```bash
dotnet run --project Bookstore.Web
```

Check application logs for any platform-specific exceptions at runtime.