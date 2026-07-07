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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings that could indicate runtime issues.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- `appsettings.json` exists in `Bookstore.Web` and contains the correct connection strings and application settings.
- Any environment-specific configuration (e.g., `appsettings.Development.json`) is present and accurate.
- If `Web.config` transforms were previously used, ensure that equivalent configuration is now handled via `appsettings.json` or environment variables.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider) is correctly referenced and compatible with the target .NET version.
- Any existing migrations are present under the `Migrations` folder.
- Run the following command to apply migrations to a local or development database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations do not exist or need to be regenerated:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and confirm the application loads correctly.

Check the following functional areas manually:

- Application startup and home page rendering
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Form submissions and data writes

---

## 6. Run Existing Tests

If a test project exists in the solution, execute all tests to confirm existing functionality is intact.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to the migration or pre-existing issues. Pay particular attention to tests that cover the data access layer, as Entity Framework behavior can differ between .NET Framework and cross-platform .NET.

---

## 7. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that were available in .NET Framework but are not available or behave differently in cross-platform .NET. Common areas to review include:

- `System.Web` references (these are not available in cross-platform .NET)
- Windows-specific APIs such as the registry, WCF, or MSMQ
- Any use of `HttpContext` that may need to be updated to use `IHttpContextAccessor`
- Third-party libraries that may still target .NET Framework only

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to identify remaining compatibility concerns.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` folder to confirm all required files are present, including static assets, configuration files, and the compiled binaries.