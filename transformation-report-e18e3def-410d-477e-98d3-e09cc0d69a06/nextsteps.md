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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values (connection strings, application settings, etc.) that were previously in `Web.config`.
- Environment-specific configuration files such as `appsettings.Development.json` and `appsettings.Production.json` are present and correctly populated.
- Any `<connectionStrings>` or `<appSettings>` entries from the old `Web.config` have been migrated to `appsettings.json`.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, validate the data layer carefully:

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to a version compatible with cross-platform .NET.
- If using Entity Framework Core, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a local development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication, etc.).
- Check the console output and application logs for any runtime exceptions or warnings.

---

## 6. Execute Unit and Integration Tests

If the solution contains a test project, run all tests to validate correctness after the migration.

```bash
dotnet test
```

- Review any failing tests. Failures may indicate runtime behavioral differences between .NET Framework and cross-platform .NET that were not caught at compile time.
- Pay particular attention to tests covering the `Bookstore.Domain` and `Bookstore.Data` layers, as data access and domain logic are the most likely areas to surface subtle incompatibilities.

---

## 7. Check for Platform-Specific API Usage

Even without build errors, some APIs may have been available on .NET Framework but behave differently or throw `PlatformNotSupportedException` at runtime on cross-platform .NET. Use the .NET Upgrade Assistant compatibility analyzer or the API compatibility tool to check:

```bash
dotnet tool install -g dotnet-apicompat
```

Alternatively, review the Microsoft documentation on [.NET Framework to .NET compatibility](https://learn.microsoft.com/en-us/dotnet/core/porting/net-framework-tech-unavailable) for known problem areas such as:

- `System.Web` dependencies
- Windows Communication Foundation (WCF) client/server usage
- Windows-specific registry or file path assumptions

---

## 8. Validate Target Framework Monikers

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version of cross-platform .NET (for example, `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correctly structured.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets, configuration files, and binaries are present before deploying to the target environment.