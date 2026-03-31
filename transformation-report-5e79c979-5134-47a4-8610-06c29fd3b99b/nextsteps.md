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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Behavior

### 3.1 Check Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains all settings that were previously in `Web.config` or `App.config`.
- Verify that connection strings, logging configuration, and any application-specific settings have been correctly migrated.

### 3.2 Check Entity Framework or Data Access Layer

In `Bookstore.Data`, verify the following:

- If using Entity Framework, confirm the correct version (EF Core) is referenced and that migrations are present and up to date.
- Run any pending migrations against a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the `DbContext` is registered correctly in the dependency injection container within `Bookstore.Web`.

### 3.3 Run the Application Locally

Start the web application and verify basic functionality:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and confirm that pages load without errors.
- Check the application logs for any runtime exceptions.
- Test core workflows such as browsing, searching, and any data entry forms.

---

## 4. Run Existing Tests

If the solution contains test projects, execute them to validate that existing functionality has not regressed:

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to tests that cover data access or external integrations, as these areas are most likely to be affected by the migration.

---

## 5. Review Platform-Specific Code

Search the codebase for any APIs or patterns that may have been available in .NET Framework but behave differently or are unavailable in cross-platform .NET:

- `System.Web` references (these should have been removed or replaced)
- `HttpContext` usage outside of the request pipeline
- Windows-specific APIs such as the registry, WCF, or MSMQ
- `BinaryFormatter` usage, which is disabled by default in modern .NET

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining compatibility concerns.

---

## 6. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 7. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files are present, then deploy the contents to the target hosting environment (IIS, Linux server, Azure App Service, etc.).

For IIS hosting, ensure the [ASP.NET Core Hosting Bundle](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/iis/) is installed on the server.