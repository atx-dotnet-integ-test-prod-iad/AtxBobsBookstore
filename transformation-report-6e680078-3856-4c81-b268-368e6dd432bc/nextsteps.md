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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to their latest versions that support the current .NET target.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility, as these may indicate subtle issues that did not surface as hard errors.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the traditional sense. Verify the following:

- `appsettings.json` contains all necessary configuration values (connection strings, app settings, etc.) that were previously in `Web.config`.
- Environment-specific overrides are in place via `appsettings.Development.json` or `appsettings.Production.json` as needed.
- Any configuration transformations that existed in the legacy project have been manually replicated.

---

## 4. Verify the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) is targeting the correct provider package for cross-platform .NET (e.g., `Microsoft.EntityFrameworkCore.SqlServer` rather than the legacy `EntityFramework` package).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist, generate an initial migration and review it before applying:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (browsing, searching, and any data entry flows).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Check for Platform-Specific Code

Search the solution for any APIs that were Windows-specific and may not function correctly on Linux or macOS if cross-platform deployment is intended.

Areas to check:

- Use of `System.Web` namespaces (these are not available in cross-platform .NET).
- Windows registry access (`Microsoft.Win32.Registry`).
- Windows-only authentication mechanisms (e.g., Windows Authentication, NTLM).
- File path separators — use `Path.Combine` rather than hardcoded backslashes.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate that business logic and data access behavior are intact after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new .NET runtime.

---

## 8. Validate Static Assets and Middleware (Bookstore.Web)

- Confirm that static files (CSS, JavaScript, images) are being served correctly. In cross-platform .NET, `UseStaticFiles()` middleware must be explicitly configured in `Program.cs` or `Startup.cs`.
- Verify that routing, model binding, and view rendering behave as expected by navigating through the full application.
- If Razor Views or Razor Pages are used, confirm that view compilation succeeds and that no legacy `System.Web.Mvc` references remain.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, assets, and dependencies are present before deploying to the target environment.