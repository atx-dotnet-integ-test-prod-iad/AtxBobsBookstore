# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

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

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test output carefully. Any failing tests should be investigated before proceeding further.

---

## 4. Verify Entity Framework Core Migrations (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm that migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

If the database schema needs to be updated or re-applied:

```bash
dotnet ef database update --project app/Bookstore.Data
```

Ensure the connection string in your configuration files (`appsettings.json`) is correct for your target environment.

---

## 5. Validate Runtime Behavior (Bookstore.Web)

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Check the following:
- The application starts without exceptions.
- All routes and pages load correctly.
- Data access through `Bookstore.Data` and domain logic in `Bookstore.Domain` function as expected end-to-end.
- Review application logs for any runtime warnings or errors.

---

## 6. Review Configuration Files

Confirm that the following have been updated for cross-platform .NET:

- `appsettings.json` and `appsettings.Production.json` contain correct environment-specific values.
- Any file paths used in code use `Path.Combine` rather than hardcoded backslash separators, to ensure cross-platform compatibility.
- Authentication, authorization, and middleware configurations are consistent with the ASP.NET Core model.

---

## 7. Check for Removed or Changed APIs

Review the code for any usage of APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references (should have been replaced with ASP.NET Core equivalents).
- `ConfigurationManager` (should be replaced with `IConfiguration`).
- `HttpContext.Current` (should be replaced with injected `IHttpContextAccessor`).
- Windows-specific APIs that may not function on Linux or macOS.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling if further analysis is needed.

---

## 8. Publish the Application

Once validation is complete, publish the application for your target environment:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files and assets are present before deploying to the target server.