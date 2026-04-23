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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of date or missing, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, to confirm that the data layer and domain logic are functioning correctly end to end.

---

## 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) in `Bookstore.Web` to confirm the following:

- Connection strings are correct for the target environment.
- Any configuration keys that were previously stored in `Web.config` have been properly migrated to the new JSON-based configuration system.
- Logging configuration is present and appropriate.

---

## 7. Check for Removed or Changed APIs

Review the code for any usage of APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core.
- Any Windows-specific APIs (e.g., registry access, Windows identity) that may not behave the same on non-Windows platforms.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining compatibility concerns.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and configuration files are present before deploying to the target environment.