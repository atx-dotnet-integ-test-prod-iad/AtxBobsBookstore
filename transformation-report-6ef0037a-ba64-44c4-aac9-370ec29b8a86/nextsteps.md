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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp3.1`, `net5.0`, or `net6.0`, update them accordingly, as those versions are out of support.

---

## 4. Check for Removed or Changed APIs

Even when a project builds successfully, certain APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Pay particular attention to:

- **`System.Web` references**: These are not available in cross-platform .NET. If any code relied on `HttpContext`, `HttpRequest`, or similar types from `System.Web`, confirm they have been replaced with their `Microsoft.AspNetCore.Http` equivalents.
- **`ConfigurationManager`**: If used, ensure it has been replaced with `Microsoft.Extensions.Configuration`.
- **`App.config` / `Web.config`**: These are not used in ASP.NET Core. Configuration should now be handled via `appsettings.json`.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral differences between .NET Framework and cross-platform .NET.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, verify the following:

- The connection string in `appsettings.json` is correctly configured for the target environment.
- If Entity Framework is used, confirm the correct version of `Microsoft.EntityFrameworkCore` and the appropriate database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are referenced.
- Run any pending migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the application locally to confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any authenticated routes, to confirm end-to-end functionality.

---

## 8. Review Middleware and Startup Configuration

In ASP.NET Core, application configuration is handled in `Program.cs` (and optionally `Startup.cs` in older ASP.NET Core patterns). Confirm the following are properly configured:

- Authentication and authorization middleware, if applicable.
- Static file serving (`app.UseStaticFiles()`).
- Routing (`app.UseRouting()` and `app.MapControllers()` or `app.MapRazorPages()`).
- Any custom middleware that was migrated from HTTP modules or HTTP handlers in the original .NET Framework project.

---

## 9. Verify Logging Configuration

Ensure that logging has been configured using `Microsoft.Extensions.Logging`. If the original project used `log4net` or `NLog`, confirm the appropriate provider package has been added and configured in `appsettings.json` or `Program.cs`.

---

## 10. Test on Target Operating System

Since the goal of the migration is cross-platform support, if the application is intended to run on Linux or macOS, test it explicitly on those platforms. Pay attention to:

- **File path separators**: Use `Path.Combine` rather than hardcoded backslashes.
- **Case-sensitive file systems**: Linux file systems are case-sensitive, so verify that all file references, view names, and static asset paths use consistent casing.