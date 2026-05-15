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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, locate them in the respective `.csproj` files and replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains all configuration values that were previously in `Web.config` or `App.config`.
- Verify that connection strings, application settings, and any environment-specific values have been correctly migrated.
- If `Web.config` transforms were used previously, ensure equivalent environment-based configuration is in place using `appsettings.{Environment}.json` or environment variables.

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is used, verify the correct version (EF Core) is referenced and that migrations are present and up to date.
- Run the following to check pending migrations:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated, apply migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to verify functional correctness:

```bash
dotnet test
```

Review any failing tests. Pay particular attention to:

- Tests that rely on `HttpContext`, `System.Web`, or other APIs that differ between .NET Framework and modern .NET.
- Tests that use mocking frameworks — confirm the versions in use are compatible with the target .NET version.

---

## 6. Run the Application Locally

Start the `Bookstore.Web` project locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Development
```

Verify the following:

- The application starts without exceptions.
- Database connectivity is functional.
- Core application flows (browsing, searching, and purchasing books, if applicable) behave as expected.
- Static files, routing, and middleware are functioning correctly.

---

## 7. Check for Removed or Changed APIs

Review the code in all three projects for usage of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Common areas to check include:

- `System.Web` namespace usage — this namespace is not available in modern .NET.
- `ConfigurationManager` — replace with `IConfiguration` via dependency injection.
- `HttpContext.Current` — replace with injected `IHttpContextAccessor`.
- Binary serialization (`BinaryFormatter`) — this is disabled by default in modern .NET.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool if a more thorough API compatibility check is needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output is complete before deploying to the target environment.