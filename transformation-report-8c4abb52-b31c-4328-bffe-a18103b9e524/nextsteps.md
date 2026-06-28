# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected in any of the three projects in the solution:

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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility analyzers.

---

## 3. Review Configuration Files

- Verify that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- Confirm that any configuration previously stored in `Web.config` or `App.config` has been properly migrated to the `appsettings.json` format or the .NET configuration system.

---

## 4. Verify Database Connectivity

If the project uses Entity Framework, confirm the following:

- The connection string in `appsettings.json` points to the correct database instance.
- Run any pending migrations to ensure the database schema is up to date.

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

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

- Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`).
- Walk through the core application workflows (e.g., browsing books, managing inventory) to confirm expected behavior.

---

## 6. Execute Automated Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

- Review test results for any failures that may indicate behavioral regressions introduced during migration.
- If no tests currently exist, consider adding unit tests for the domain layer (`Bookstore.Domain`) and integration tests for the data layer (`Bookstore.Data`).

---

## 7. Check for Platform-Specific Code

Even without build errors, runtime issues can arise from platform-specific APIs that were available in .NET Framework but behave differently or are unavailable in cross-platform .NET. Review the codebase for:

- Use of `System.Web` types that may have been shimmed or replaced.
- Windows-specific registry, file path, or security APIs.
- Any third-party libraries that may still target .NET Framework only.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` compatibility tooling if needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

- Review the contents of the `./publish` directory to confirm all required files are present.
- Test the published output by running it directly:

```bash
dotnet ./publish/Bookstore.Web.dll
```