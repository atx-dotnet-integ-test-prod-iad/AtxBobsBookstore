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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or target framework mismatches.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing target frameworks (e.g., `net6.0` in one project and `net8.0` in another) can cause runtime compatibility issues even when the build succeeds.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect each project for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- `Microsoft.Web.*` packages
- Windows Registry access
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

Replace any identified Windows-specific code with cross-platform equivalents from ASP.NET Core or the .NET BCL.

---

## 5. Review Configuration Files

Ensure that `web.config` or `app.config` files have been replaced or supplemented by `appsettings.json`. Verify that:

- Connection strings are present in `appsettings.json`
- Environment-specific settings use `appsettings.{Environment}.json`
- Any configuration previously read via `ConfigurationManager` has been migrated to `IConfiguration`

---

## 6. Database Migration Validation

If `Bookstore.Data` uses Entity Framework, verify that migrations are up to date and compatible with the new runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied to a database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run Unit Tests

If a test project exists in the solution, execute the tests to validate core logic:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they reflect regressions introduced during migration or pre-existing issues.

---

## 8. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary functionality, paying attention to:

- Data access operations through `Bookstore.Data`
- Domain logic in `Bookstore.Domain`
- Routing, middleware, and authentication in `Bookstore.Web`

---

## 9. Review Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) to confirm that middleware is registered correctly for ASP.NET Core. Common areas to verify:

- Authentication and authorization middleware order
- Static file serving
- Exception handling middleware
- Dependency injection registrations for services and repositories

---

## 10. Validate Logging

Confirm that logging has been migrated from any legacy logging framework (e.g., `log4net`, `NLog` with legacy config) to use `Microsoft.Extensions.Logging` or a compatible provider configured through the ASP.NET Core host builder.