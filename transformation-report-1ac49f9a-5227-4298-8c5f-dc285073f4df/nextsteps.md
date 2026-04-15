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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility. While warnings do not prevent a build, they can indicate areas that may cause runtime issues.

---

## 3. Review Configuration Files

- Verify that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains the correct connection strings and application settings that were previously in `Web.config` or `App.config`.
- Confirm that any environment-specific settings are properly separated using the `appsettings.{Environment}.json` pattern.
- Check that the `Program.cs` and `Startup.cs` (or the minimal hosting model in `Program.cs` if using .NET 6+) correctly registers all services, middleware, and database contexts that were previously configured in the legacy project.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the data layer functions as expected.

- Confirm that Entity Framework Core (or whichever ORM is in use) migrations are present and up to date.
- If using EF Core, run the following to check the current migration state:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- If the database schema needs to be created or updated, apply migrations:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform an initial smoke test.

```bash
dotnet run --project app/Bookstore.Web
```

- Navigate to the application URL shown in the console output.
- Verify that the application loads without errors.
- Check that database connectivity is working by exercising features that read from or write to the database.
- Review the console and any log output for runtime exceptions or warnings.

---

## 6. Execute Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results carefully. Any failing tests should be investigated to determine whether they indicate a genuine regression introduced during migration or a test that requires updating to reflect the new project structure.

---

## 7. Verify Platform-Specific Code

Cross-platform migration can surface issues with code that previously relied on Windows-specific behavior. Manually review the following areas:

- **File paths**: Ensure `Path.Combine` is used rather than hardcoded backslashes.
- **Registry access**: Any use of `Microsoft.Win32.Registry` will not function on Linux or macOS.
- **Windows Authentication**: If the application used Windows Authentication, confirm the replacement authentication mechanism is correctly configured.
- **Case sensitivity**: Linux file systems are case-sensitive. Verify that file references, view names, and static asset paths use consistent casing.

---

## 8. Review Removed or Changed APIs

Some .NET Framework APIs are not available in cross-platform .NET. Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining usage of unsupported APIs that may only surface at runtime.