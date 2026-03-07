# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention even if they do not prevent compilation.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were removed or significantly changed between .NET Framework and modern .NET. Common areas to check include:

- `System.Web` references — these are not available in modern .NET and must be replaced with `Microsoft.AspNetCore` equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usages.
- `ConfigurationManager` — replaced by `Microsoft.Extensions.Configuration`.
- `EntityFramework` (classic) — should be migrated to `Microsoft.EntityFrameworkCore`.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate runtime behavior:

```bash
dotnet test
```

If no tests exist, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding.

---

## 6. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and manually verify the following:

- Pages load without errors.
- Database connectivity is functional (check connection strings in `appsettings.json`).
- Any authentication or authorization flows behave correctly.

---

## 7. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Development.json`) are correctly configured. In modern .NET, configuration is no longer sourced from `Web.config` or `App.config` by default. Verify:

- Database connection strings are present and correct.
- Any environment-specific settings are properly separated by environment.
- Sensitive values are not hardcoded and are instead sourced from environment variables or a secrets manager.

---

## 8. Validate Data Layer

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- Migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

- The database schema matches the current model by running:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy it to your target hosting environment (e.g., IIS, a Linux server, or Azure App Service).

For IIS hosting on Windows, ensure the **ASP.NET Core Hosting Bundle** is installed on the server.