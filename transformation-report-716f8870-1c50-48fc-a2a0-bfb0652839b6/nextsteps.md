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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). For example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid compatibility issues between them.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Check any database access code (e.g., Entity Framework). If the project was using Entity Framework 6, it may need to be migrated to Entity Framework Core. Verify connection strings and database provider packages are correct for the new runtime.
- **`Bookstore.Web`**: If this was previously an ASP.NET Web Forms or ASP.NET MVC (.NET Framework) project, confirm it has been migrated to ASP.NET Core. Web Forms is not supported in cross-platform .NET and would require a rewrite to Razor Pages or MVC.
- **`Bookstore.Domain`**: Review any use of `System.Configuration`, `System.Web`, or other namespaces that are not available in cross-platform .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, run the tests to validate that core logic remains intact after migration.

```bash
dotnet test
```

If no test project exists, consider manually exercising the key domain and data access logic to verify correctness.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the displayed local URL and verify:

- Pages load without errors.
- Database connectivity works (if applicable).
- Core application workflows function correctly (e.g., browsing books, placing orders).

---

## 7. Review Configuration Files

In cross-platform .NET, `Web.config` and `App.config` are replaced by `appsettings.json`. Confirm that:

- All necessary configuration values (connection strings, app settings) have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- The application reads configuration using `IConfiguration` rather than `ConfigurationManager`.

---

## 8. Verify Runtime on Target Platform

If the application is intended to run on Linux or macOS, test it explicitly on that platform. Some issues (e.g., file path casing, platform-specific APIs) only surface at runtime on non-Windows systems.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check application logs for any runtime exceptions that did not appear during the build.