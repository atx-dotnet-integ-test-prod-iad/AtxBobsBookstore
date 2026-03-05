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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects can cause runtime issues even when the build succeeds.

Example of what to look for:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET compared to .NET Framework. Pay particular attention to:

- **`System.Web` dependencies** — These are not available in cross-platform .NET. Ensure `Bookstore.Web` has been fully migrated to ASP.NET Core equivalents.
- **Entity Framework** — If `Bookstore.Data` uses Entity Framework, confirm it has been migrated from EF 6 to EF Core and that all migrations are compatible.
- **Configuration** — `Web.config` and `App.config` are replaced by `appsettings.json` and the `Microsoft.Extensions.Configuration` system. Verify all configuration values have been moved appropriately.
- **HTTP Modules and Handlers** — These must be replaced with ASP.NET Core middleware.

---

## 5. Run Existing Tests

If the solution contains test projects, run them to validate that existing behavior has been preserved.

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the migration rather than pre-existing failures.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` connects to a database, verify the connection string in `appsettings.json` is correct and that the application can connect and perform basic read/write operations at runtime.

If using EF Core, apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that:

- Pages load correctly
- Data is read from and written to the database
- Authentication and authorization behave as expected, if applicable
- Static assets (CSS, JavaScript, images) are served correctly

---

## 8. Review Middleware and Startup Configuration

In ASP.NET Core, application startup is configured in `Program.cs` (and optionally `Startup.cs` in older ASP.NET Core styles). Confirm the middleware pipeline is ordered correctly, including:

- Routing
- Authentication/Authorization
- Static files
- Exception handling

---

## 9. Check Logging

Ensure that logging has been configured using `Microsoft.Extensions.Logging` or a compatible provider. Any legacy logging frameworks (e.g., `log4net`, `NLog`) should be verified for .NET compatibility or replaced with modern alternatives.

---

## 10. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present, including `appsettings.json` and any static assets.