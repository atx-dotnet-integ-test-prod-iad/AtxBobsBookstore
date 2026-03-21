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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm the selected version is still within its support window.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, verify that no Windows-only APIs are being used without appropriate guards. Run the .NET Compatibility Analyzer if it is not already enabled:

```xml
<EnableNETAnalyzers>true</EnableNETAnalyzers>
<AnalysisMode>All</AnalysisMode>
```

Add these properties to each `.csproj` file if they are not present. Address any `CA1416` platform compatibility warnings that appear.

---

## 5. Validate the Data Layer

In `Bookstore.Data`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is referencing a compatible version.
- Any existing migrations are still valid by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated, apply migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to verify that business logic and data access behavior remain intact:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the old .NET Framework and the new .NET runtime.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following manually:

- Application startup completes without exceptions.
- All routes and pages load as expected.
- Database read and write operations function correctly.
- Authentication and authorization flows work if applicable.
- Static files (CSS, JavaScript, images) are served correctly.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration values that were previously in `Web.config` or `App.config`. Key areas to check include:

- Connection strings
- Logging configuration
- Application-specific settings

Legacy `Web.config` transformation behavior is not supported in the same way on .NET. Confirm that environment-specific settings are handled using `appsettings.{Environment}.json` files or environment variables.

---

## 9. Verify Logging and Error Handling

Confirm that the logging framework is properly configured in `Program.cs` or `Startup.cs`. If the project previously used a third-party logger (e.g., NLog, Serilog, log4net), verify the package version is compatible with the current target framework and that the configuration has been updated accordingly.