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

Ensure the build completes with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with the following command:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences introduced during the migration.

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, verify that any Entity Framework Core migrations are up to date and compatible with the new target framework.

List existing migrations:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the database schema needs to be updated, apply migrations:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate through the application and verify that core functionality such as browsing, data retrieval, and any authentication flows work as expected.

---

## 6. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) for the following:

- Connection strings are valid and pointing to the correct database.
- Any configuration keys that were previously stored in `Web.config` have been correctly migrated to `appsettings.json`.
- Logging configuration is appropriate for the target environment.

---

## 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 8. Check for Removed or Changed APIs

Review the code in all three projects for usage of any APIs that have been removed or significantly changed in modern .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core.
- Any use of `ConfigurationManager`, which should be replaced with the `Microsoft.Extensions.Configuration` approach.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify that all required assets, static files, and configuration files are present before deploying to the target environment.