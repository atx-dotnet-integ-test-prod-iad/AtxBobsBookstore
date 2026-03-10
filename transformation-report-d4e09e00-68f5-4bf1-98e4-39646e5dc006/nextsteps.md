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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, consider replacing them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net472` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Even with a clean build, certain APIs behave differently or have been removed in modern .NET. Pay particular attention to the following areas:

- **`System.Web` dependencies** — These are not available in .NET Core or later. If `Bookstore.Web` previously relied on `System.Web` (e.g., `HttpContext`, `HttpRequest`), confirm these have been replaced with their `Microsoft.AspNetCore` equivalents.
- **Entity Framework** — If `Bookstore.Data` uses Entity Framework, confirm it has been migrated from `EntityFramework` (EF6) to `Microsoft.EntityFrameworkCore` if that was part of the transformation.
- **Configuration** — Confirm that `Web.config` or `App.config` based configuration has been replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` system.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic.

```bash
dotnet test
```

If no test project exists, consider writing basic integration or unit tests for the domain and data layers before proceeding to production deployment.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm the following:

- The application starts without runtime exceptions.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Core application routes and pages load correctly.
- Any authentication or authorization middleware is functioning properly.

---

## 7. Review Middleware and Startup Configuration

In ASP.NET Core, application startup is configured in `Program.cs` (and optionally `Startup.cs` in older templates). Confirm the middleware pipeline is correctly ordered, including:

- Routing
- Authentication and Authorization (if applicable)
- Static files
- Exception handling

---

## 8. Validate Data Layer

If `Bookstore.Data` uses Entity Framework Core, run any pending migrations against a development database to confirm the schema is correct.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Verify that data reads and writes function correctly through the application.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.