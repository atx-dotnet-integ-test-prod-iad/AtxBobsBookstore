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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

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

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- The connection string in `appsettings.json` (or `appsettings.Development.json`) is correctly configured for the target database.
- If Entity Framework Core is in use, confirm that migrations are up to date:

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

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser and confirm that core functionality behaves as expected.
- Check the console output and application logs for any runtime exceptions or unhandled errors.
- Pay attention to any middleware, authentication, or routing configurations that may have changed behavior between the legacy framework and cross-platform .NET.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently than legacy .NET Framework projects. Confirm the following:

- `Web.config` transformations have been replaced with `appsettings.json` and environment-specific variants (`appsettings.Production.json`, etc.).
- Any settings previously stored in `Web.config` such as connection strings, app settings, or HTTP handlers have been moved to the appropriate `appsettings.json` entries or middleware registrations in `Program.cs`.

---

## 7. Validate Static Files and Razor Views

If `Bookstore.Web` uses Razor views or serves static files:

- Confirm that static assets (CSS, JavaScript, images) are located under the `wwwroot` folder.
- Verify that Razor views render correctly and that any Tag Helpers or HTML Helpers function as expected under the new framework version.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and static assets are present before deploying to the target environment.