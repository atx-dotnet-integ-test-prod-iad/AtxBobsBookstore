# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are up to date and compatible with the new framework version:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied to a local database for testing:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the connection string in `appsettings.json` is correctly configured for your target environment.

---

## 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL indicated in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify the following:

- Pages load without errors
- Data is retrieved and displayed correctly from the database
- Any forms or write operations function as expected
- Authentication and authorization behave correctly if applicable

---

## 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` and environment variables rather than `Web.config` or `App.config`. Confirm the following:

- All connection strings have been moved to `appsettings.json` or environment-specific variants such as `appsettings.Production.json`
- Any configuration keys previously read via `ConfigurationManager` are now accessed through `IConfiguration`
- Sensitive values are not hardcoded and are managed through environment variables or a secrets manager

---

## 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or dependencies that may not function correctly on Linux or macOS if cross-platform support is a requirement. Common areas to check include:

- File path separators — use `Path.Combine` rather than hardcoded backslashes
- Registry access — not available on non-Windows platforms
- Windows-specific NuGet packages or COM interop references

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

Verify the contents of the `./publish` directory and confirm the application starts correctly from that output folder before deploying to the target environment.