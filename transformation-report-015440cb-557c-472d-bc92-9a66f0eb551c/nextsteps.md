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

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, consider adding unit tests for the `Bookstore.Domain` layer and integration tests for `Bookstore.Data` to verify that data access logic behaves correctly against the target database.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that your migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Verify that the schema matches expectations before pointing the application at a production database.

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Walk through the core application workflows (e.g., browsing books, managing inventory, placing orders) to confirm that behavior matches the pre-migration baseline.

---

## 6. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) for the following:

- Connection strings are updated and valid for the target environment.
- Any configuration keys that were previously stored in `Web.config` have been correctly migrated to the `appsettings.json` format.
- Logging configuration is appropriate for each environment.

---

## 7. Review Middleware and Startup Configuration

Open `Program.cs` (or `Startup.cs` if still present) in `Bookstore.Web` and confirm:

- Middleware is registered in the correct order.
- Authentication and authorization configuration, if present, is using the current ASP.NET Core APIs.
- Static file serving, routing, and error handling are configured correctly.

---

## 8. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and currently supported version of .NET.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected assets, configuration files, and binaries are present before deploying to the target environment.