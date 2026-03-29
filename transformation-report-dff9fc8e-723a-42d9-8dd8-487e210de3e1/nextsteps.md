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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid compatibility mismatches between assemblies.

---

## 4. Verify Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) exist in `Bookstore.Web` and contain the correct connection strings and application settings.
- If the original project used `Web.config` or `App.config`, verify that all relevant configuration values have been migrated to `appsettings.json` or the appropriate .NET configuration provider.

---

## 5. Validate the Data Layer

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to its .NET-compatible version.
- If Entity Framework Core is being used, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations against a development database to confirm the schema is correct:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, placing orders) to confirm expected behavior.

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to the migration or pre-existing issues.

---

## 8. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present in modern .NET. Review the following areas manually:

- **`HttpContext` usage** — Ensure access to `HttpContext` goes through dependency injection (`IHttpContextAccessor`) rather than `HttpContext.Current`.
- **`System.Web` references** — These are not available in modern .NET. Any remaining references must be replaced with their ASP.NET Core equivalents.
- **`ConfigurationManager`** — Replace with `IConfiguration` injected via the ASP.NET Core dependency injection system.

---

## 9. Review Middleware and Startup Configuration

Confirm that `Program.cs` (or `Startup.cs` if still present) correctly registers all required services and middleware, including:

- Database context registration
- Authentication and authorization middleware
- Static file serving
- Routing configuration

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.