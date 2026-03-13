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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing basic tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, it likely uses Entity Framework Core or a similar ORM. Verify the following:

- The connection string in `appsettings.json` (or equivalent) is correctly configured for the target environment.
- If using Entity Framework Core, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application locally to verify that it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output and manually verify that core application flows, such as browsing, searching, and any data entry forms, function correctly.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently from legacy .NET Framework projects. Verify the following:

- `web.config` transforms or IIS-specific settings have been replaced or are handled by `appsettings.json` and middleware in `Program.cs` or `Startup.cs`.
- Any file paths hardcoded in configuration use `Path.Combine` or forward-slash separators to ensure cross-platform compatibility.
- Environment-specific settings are separated using `appsettings.Development.json` and `appsettings.Production.json` as appropriate.

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any remaining Windows-specific APIs that may not function correctly on Linux or macOS if cross-platform deployment is intended. Common areas to check include:

- Registry access (`Microsoft.Win32.Registry`)
- Windows-specific authentication or identity APIs
- File system assumptions (drive letters, path separators)

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` package where needed.

---

## 8. Publish the Application

Once validation is complete, publish the application to the desired target:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and configuration files are present before deploying to the target environment.