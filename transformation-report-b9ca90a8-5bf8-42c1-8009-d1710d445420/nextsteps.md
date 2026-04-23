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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp3.1`, `net5.0`, or `net6.0`, update them to a current long-term support (LTS) release.

---

## 4. Check for Removed or Changed APIs

Even without build errors, runtime issues can arise from APIs that changed behavior between .NET Framework and modern .NET. Pay particular attention to:

- `System.Web` usages — this namespace is not available in cross-platform .NET. Ensure `Bookstore.Web` has fully migrated away from it.
- `HttpContext`, `HttpRequest`, and `HttpResponse` — confirm these are sourced from `Microsoft.AspNetCore.Http`.
- Entity Framework — if `Bookstore.Data` uses Entity Framework, confirm it references `Microsoft.EntityFrameworkCore` and not the older `EntityFramework` (6.x) package.
- Configuration — ensure `System.Configuration.ConfigurationManager` usages have been replaced with `Microsoft.Extensions.Configuration`.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the domain and data layers to verify expected behavior before deploying.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs without runtime exceptions.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and verify:

- Pages load without HTTP 500 errors.
- Database connectivity is functional (check connection strings in `appsettings.json`).
- Any authentication or authorization flows behave as expected.

---

## 7. Validate Configuration Files

Ensure that `appsettings.json` (and `appsettings.Production.json` if applicable) contains all required configuration values that were previously stored in `Web.config` or `App.config`. Common entries to verify include:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.