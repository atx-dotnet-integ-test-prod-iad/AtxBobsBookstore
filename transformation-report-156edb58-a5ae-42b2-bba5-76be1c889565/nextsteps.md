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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they indicate a regression introduced during the migration or a pre-existing issue.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm that:

- The connection strings in your configuration files (`appsettings.json` or environment variables) are correct and accessible from the new runtime environment.
- Any Entity Framework Core migrations are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If you were previously using Entity Framework 6 (EF6) and have migrated to EF Core, verify that all queries, relationships, and model configurations behave correctly against your target database.

---

## 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm that:

- All relevant settings have been moved to `appsettings.json` or environment-specific variants such as `appsettings.Production.json`.
- Any configuration previously handled by `System.Configuration.ConfigurationManager` has been replaced with `Microsoft.Extensions.Configuration`.

---

## 6. Run the Web Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that:

- Pages load without errors.
- Data is retrieved and displayed correctly from the database.
- Any authentication or authorization mechanisms function as expected.
- Static assets (CSS, JavaScript, images) are served correctly.

---

## 7. Review Middleware and HTTP Pipeline

If `Bookstore.Web` was previously an ASP.NET MVC or Web Forms project, confirm that the middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured for ASP.NET Core, including:

- Routing configuration (`app.UseRouting()`, `app.MapControllers()`, etc.)
- Authentication and authorization middleware order.
- Static file serving (`app.UseStaticFiles()`).
- Error handling middleware.

---

## 8. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or packages that may cause issues on non-Windows platforms if cross-platform deployment is intended:

- References to `Microsoft.Win32` or the Windows Registry.
- Usage of Windows-specific file path formats.
- Any P/Invoke calls targeting Windows DLLs.

Use the .NET Compatibility Analyzer or review the output of:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 9. Publish the Application

Once validation is complete, publish the application to your target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including configuration files and static assets, are present before deploying to the target server.