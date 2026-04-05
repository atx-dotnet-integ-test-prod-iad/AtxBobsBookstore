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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, consider finding their cross-platform equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net472` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not available or have changed in cross-platform .NET. Review the following areas manually:

- **`System.Web` references**: These are not available in cross-platform .NET. Any remaining usage should be replaced with `Microsoft.AspNetCore` equivalents.
- **`HttpContext`, `HttpRequest`, `HttpResponse`**: Ensure these are sourced from `Microsoft.AspNetCore.Http` and not `System.Web`.
- **`ConfigurationManager`**: Replace with `Microsoft.Extensions.Configuration` if still in use.
- **`EntityFramework` (non-Core)**: If `Bookstore.Data` was using classic Entity Framework, confirm it has been migrated to `Microsoft.EntityFrameworkCore`.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to surface any remaining API compatibility issues.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core business logic in `Bookstore.Domain` and data access behavior in `Bookstore.Data`.

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for critical paths such as data retrieval and domain model validation before deploying.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connections in `Bookstore.Data` are functioning correctly.
- All pages and endpoints return expected responses.
- Any authentication or authorization flows behave as expected.

---

## 7. Validate Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings previously in `Web.config` have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`.
- Sensitive values such as connection strings or API keys are managed via environment variables or a secrets manager rather than being stored in source files.

---

## 8. Verify Database Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that migrations are up to date and can be applied cleanly.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations against your target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy them to your target hosting environment.