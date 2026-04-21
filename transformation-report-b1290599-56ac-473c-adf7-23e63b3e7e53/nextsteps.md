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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether the failure is due to the migration or a pre-existing issue.

---

## 4. Verify Entity Framework Core Migrations (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm that migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

If the project was previously using Entity Framework 6 and has been migrated to Entity Framework Core, existing migrations may need to be recreated. Verify that the database schema produced by the migrations matches the expected schema.

To apply migrations against a development database:

```bash
dotnet ef database update --project app/Bookstore.Data
```

---

## 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config`, including connection strings and application settings.
- Environment-specific configuration files such as `appsettings.Development.json` are present and correct.
- Any configuration transforms that existed in the legacy project have been manually replicated.

---

## 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify core functionality, including:

- Page rendering and navigation
- Database read and write operations
- Authentication and authorization, if applicable
- Any file upload or static file serving behavior

---

## 7. Check for Platform-Specific Code

Search the solution for any remaining usage of Windows-specific APIs that may not behave correctly on Linux or macOS if cross-platform support is required. Common areas to check include:

- Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions (backslashes, drive letters)
- `System.Drawing` usage, which requires `libgdiplus` on non-Windows platforms or should be replaced with an alternative such as `SkiaSharp`

---

## 8. Review Startup and Middleware Configuration

In `Bookstore.Web`, confirm that the ASP.NET Core middleware pipeline is configured correctly in `Program.cs` or `Startup.cs`:

- Static files middleware is enabled
- Routing is configured correctly
- Any custom HTTP modules or handlers from the legacy project have been converted to ASP.NET Core middleware

---

## 9. Validate Logging

Confirm that logging is configured and functioning. ASP.NET Core uses `Microsoft.Extensions.Logging` by default. If the legacy project used a third-party logging framework such as log4net or NLog, verify that the provider has been integrated correctly and that log output is appearing as expected.

---

## 10. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including static assets and configuration files, are present before deploying to the target environment.