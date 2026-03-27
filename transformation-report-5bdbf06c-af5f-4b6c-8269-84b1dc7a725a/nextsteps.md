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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in cross-platform .NET. Review the following areas:

- **`System.Web` usage**: This namespace is not available in cross-platform .NET. Any references to it in `Bookstore.Web` should be replaced with ASP.NET Core equivalents.
- **`HttpContext`**: Ensure it is accessed via dependency injection rather than `HttpContext.Current`.
- **`ConfigurationManager`**: Replace with `Microsoft.Extensions.Configuration` and `appsettings.json`.
- **`EntityFramework` (EF6)**: If `Bookstore.Data` uses EF6, consider migrating to Entity Framework Core. Verify the package referenced is `Microsoft.EntityFrameworkCore` and not the legacy `EntityFramework` package.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected.

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral differences between .NET Framework and cross-platform .NET.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the database connection string in `appsettings.json` is correct and that migrations are up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, to confirm end-to-end functionality.

---

## 8. Review Application Configuration

Confirm that all configuration previously stored in `Web.config` or `App.config` has been migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application settings keys
- Authentication and authorization configuration

---

## 9. Check Logging

Verify that logging is configured using `Microsoft.Extensions.Logging`. If the legacy project used `log4net` or `NLog`, ensure the appropriate provider package is registered in the `Bookstore.Web` startup configuration.

---

## 10. Publish the Application

Once local validation is complete, publish the application to a target directory.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files, including `appsettings.json` and static assets, are present before deploying to the target environment.