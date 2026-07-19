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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` (or `appsettings.Development.json`) are correctly configured for the target environment.
- If Entity Framework Core is in use, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify that core functionality such as browsing, searching, and any data-driven pages work correctly.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm the following:

- All configuration values previously in `Web.config` have been moved to `appsettings.json`.
- Environment-specific settings are handled using `appsettings.{Environment}.json` files.
- Any configuration values referencing Windows-specific paths or registry entries have been updated.

---

## 7. Check for Platform-Specific Code

Review the codebase for any remaining platform-specific APIs that may not behave correctly on non-Windows operating systems. Common areas to check include:

- File path separators (use `Path.Combine` rather than hardcoded backslashes).
- Windows registry access (`Microsoft.Win32.Registry`), which is not available on Linux or macOS.
- Windows-specific authentication mechanisms such as NTLM or Windows Identity, which may require additional configuration.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.