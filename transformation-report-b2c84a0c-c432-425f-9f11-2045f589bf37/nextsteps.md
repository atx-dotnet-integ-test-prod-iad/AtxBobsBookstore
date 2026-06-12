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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netcoreapp3.1` or similar outdated monikers, update them accordingly and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Even without build errors, runtime issues can arise from APIs that behave differently in modern .NET. Pay particular attention to the following areas:

- **`System.Web` dependencies**: These do not exist in .NET 6+. Confirm that `Bookstore.Web` has been fully migrated away from `System.Web` (e.g., `HttpContext`, `HttpRequest`) to their `Microsoft.AspNetCore` equivalents.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been migrated from EF 6 to EF Core and that the `DbContext` configuration is correct.
- **Configuration**: Confirm that `Web.config` or `App.config` settings have been migrated to `appsettings.json` and are being read via `IConfiguration`.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the domain and data layers to verify expected behavior before deploying.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, to confirm end-to-end functionality.

---

## 7. Verify Database Connectivity

If `Bookstore.Data` connects to a database, confirm the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending EF Core migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Middleware and Startup Configuration

In ASP.NET Core, the application startup pipeline is configured in `Program.cs` (and optionally `Startup.cs`). Confirm that:

- Authentication and authorization middleware is registered in the correct order.
- Static files, routing, and endpoint mapping are configured correctly.
- Any custom HTTP modules or handlers from the legacy project have been replaced with the appropriate ASP.NET Core middleware.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target folder.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.