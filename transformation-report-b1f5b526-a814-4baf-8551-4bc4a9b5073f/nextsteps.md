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

- `System.Web` usages — this namespace is not available in cross-platform .NET. Ensure all references have been replaced with ASP.NET Core equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` — confirm these are sourced from `Microsoft.AspNetCore.Http`.
- `ConfigurationManager` — this should be replaced with `Microsoft.Extensions.Configuration`.
- Entity Framework — if the project uses Entity Framework, confirm it has been migrated to Entity Framework Core and that the `DbContext` configuration is compatible.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic.

```bash
dotnet test
```

If no test project exists, consider manually verifying critical paths in `Bookstore.Domain` and `Bookstore.Data`, such as data access logic and domain model behavior.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the database connection string in `appsettings.json` is correct and that migrations are up to date.

```bash
dotnet ef migrations list
dotnet ef database update
```

Confirm that the `DbContext` is registered correctly in the dependency injection container within `Bookstore.Web`.

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm runtime behavior is correct.

---

## 8. Review Application Configuration

Compare the original `Web.config` (if it existed) with the new `appsettings.json` to ensure all configuration values have been carried over, including:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Check Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to confirm that all middleware is registered in the correct order and that services are properly configured. Key areas to check:

- Authentication and authorization middleware
- Static file serving
- Routing configuration
- Exception handling middleware

---

## 10. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present before deploying to the target environment.