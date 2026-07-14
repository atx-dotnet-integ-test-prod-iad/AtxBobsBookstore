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

Review the output for any warnings related to package compatibility or deprecated packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48`, `netcoreapp3.1`, or `net6.0`, update it to a current supported version.

---

## 4. Check for Removed or Changed APIs

Even without build errors, runtime issues can arise from APIs that changed behavior between .NET Framework and modern .NET. Pay particular attention to:

- `System.Web` usages — this namespace is not available in cross-platform .NET. Any remaining references should be replaced with `Microsoft.AspNetCore` equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` — ensure these are sourced from `Microsoft.AspNetCore.Http`.
- `ConfigurationManager` — replace with `Microsoft.Extensions.Configuration`.
- `EntityFramework` (non-Core) — if `Bookstore.Data` was using classic Entity Framework, confirm it has been migrated to `Microsoft.EntityFrameworkCore`.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the domain and data layers to verify expected behavior before deploying.

---

## 6. Verify Database Connectivity

Since `Bookstore.Data` is a data access layer, confirm that:

- The connection string in `appsettings.json` is correctly configured for the target environment.
- Any Entity Framework Core migrations are up to date.

To apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

To list current migrations and verify their state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application locally to perform a manual smoke test.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core pages load, data is retrieved correctly, and no unhandled exceptions occur.

---

## 8. Review `appsettings.json` and Environment Configuration

Confirm that `appsettings.json` contains all required configuration keys that were previously stored in `Web.config` or `App.config`. Common items to check include:

- Database connection strings
- Logging configuration
- Any application-specific settings

Cross-reference with the original `Web.config` to ensure nothing was omitted during transformation.

---

## 9. Validate Static Files and Middleware Pipeline

In `Bookstore.Web`, open `Program.cs` or `Startup.cs` and confirm that the middleware pipeline is correctly configured, including:

- `app.UseStaticFiles()`
- `app.UseRouting()`
- `app.UseAuthentication()` and `app.UseAuthorization()` if applicable
- `app.MapControllers()` or `app.MapRazorPages()` depending on the project type

---

## 10. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.