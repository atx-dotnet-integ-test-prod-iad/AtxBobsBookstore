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

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may indicate compatibility issues, even if they do not prevent a successful build.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were available in .NET Framework but have been removed or changed in modern .NET. Common areas to check include:

- `System.Web` references (not available in cross-platform .NET)
- `HttpContext` and related ASP.NET types (should now use `Microsoft.AspNetCore.Http`)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `AppDomain` usage with limited support
- Windows-specific APIs such as the registry or WCF server-side components

---

## 5. Run Existing Tests

If the solution contains a test project, run the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings are correctly configured in `appsettings.json` rather than `web.config` or `app.config`
- Entity Framework (if used) migrations are up to date by running:

```bash
dotnet ef database update
```

- Confirm the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`)

---

## 7. Run the Web Application Locally

Start the web application to verify it runs correctly in a local environment:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the URL shown in the console output and manually verify that key pages and features function as expected.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration values that were previously stored in `web.config`. Key areas to check:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 9. Check Static Files and wwwroot

Verify that static assets (CSS, JavaScript, images) have been placed under the `wwwroot` folder, as this is the expected location for static files in ASP.NET Core.

---

## 10. Review Middleware and Startup Configuration

In ASP.NET Core, application configuration previously done in `Global.asax` or `Startup.cs` (in older ASP.NET Core versions) may now be located in `Program.cs`. Confirm the following middleware is correctly registered:

- Authentication and authorization
- Routing
- Static files
- Error handling