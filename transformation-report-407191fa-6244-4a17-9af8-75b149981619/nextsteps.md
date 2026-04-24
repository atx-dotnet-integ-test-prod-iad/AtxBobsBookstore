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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was reported:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Domain Layer (`Bookstore.Domain`)

Since this is the most independent project, start validation here:

- Confirm that all domain models, interfaces, and business logic compile and behave as expected.
- If unit tests exist for this layer, run them in isolation:

```bash
dotnet test Bookstore.Domain.Tests
```

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) is correctly configured for cross-platform .NET.
- If the project previously used `System.Data.SqlClient`, verify it has been replaced with `Microsoft.Data.SqlClient`.
- Check that connection strings in configuration files (`appsettings.json`) are correct and accessible.
- Apply and verify any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Run any data layer tests if available:

```bash
dotnet test Bookstore.Data.Tests
```

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Confirm that the web project starts without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and verify that core pages and functionality load correctly.
- Check that any middleware, authentication, authorization, or routing configurations that existed in the legacy project are still functioning as intended.
- If the project previously used `System.Web`, confirm all references have been replaced with their ASP.NET Core equivalents.
- Review `Program.cs` and any `Startup.cs` (if still present) to ensure service registrations and the middleware pipeline are correctly configured.

---

## 6. Configuration and Environment Settings

- Verify that `appsettings.json` and `appsettings.{Environment}.json` files contain all necessary configuration values that were previously stored in `Web.config` or `App.config`.
- Confirm that environment-specific settings (e.g., connection strings, API keys) are correctly handled using the `IConfiguration` interface.

---

## 7. Runtime and Integration Testing

- Exercise the main user-facing workflows of the bookstore application manually or through integration tests.
- Pay particular attention to:
  - Database read and write operations
  - Any file system interactions
  - Authentication and session management
  - Any third-party service integrations

---

## 8. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-targeting issues.

---

## 9. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files are present, then deploy the contents to the target hosting environment (IIS, Azure App Service, Linux server, etc.) following the standard procedure for that platform.