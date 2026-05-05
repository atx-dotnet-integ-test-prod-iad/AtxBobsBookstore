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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. If tests were previously written against .NET Framework-specific behavior (e.g., `HttpContext`, `ConfigurationManager`), they may require updates to align with the cross-platform .NET equivalents.

---

## 4. Verify Configuration

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- `appsettings.json` is present in `Bookstore.Web` and contains the necessary configuration values (connection strings, app settings, etc.).
- Any environment-specific configuration is handled via `appsettings.{Environment}.json` files.
- The `Startup.cs` or `Program.cs` correctly registers services, middleware, and the database context.

---

## 5. Validate the Data Layer

In `Bookstore.Data`, confirm the following:

- The Entity Framework (or other ORM) version being used is compatible with the target .NET version.
- Database migrations are present and up to date. Run the following to apply migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Connection strings in `appsettings.json` point to the correct database instance.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core functionality, including any pages or API endpoints that interact with `Bookstore.Domain` and `Bookstore.Data`.

---

## 7. Review Platform-Specific Code

Search the solution for any remaining code that may not behave correctly on non-Windows platforms, including:

- Use of Windows registry access
- Hardcoded Windows-style file paths (e.g., `C:\`)
- P/Invoke calls or COM interop
- `System.Web` references that may have been carried over

Use the following command to check for remaining `System.Web` references:

```bash
grep -r "System.Web" ./app --include="*.cs"
```

Address any findings before considering the migration complete.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.