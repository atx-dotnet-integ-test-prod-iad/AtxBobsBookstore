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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check for updated versions on [NuGet.org](https://www.nuget.org) and update the `.csproj` files accordingly.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to:
- Any nullable reference type warnings if the project has enabled `<Nullable>enable</Nullable>` in the `.csproj` files.
- Any platform-specific API usage that may have been silently retained during transformation.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- `appsettings.json` (and `appsettings.Development.json`) exist in `Bookstore.Web` and contain the correct configuration values such as connection strings and application settings.
- Any configuration previously in `Web.config` (e.g., connection strings, app settings, HTTP handlers) has been migrated to `appsettings.json` or the appropriate middleware registration in `Program.cs` / `Startup.cs`.
- Environment-specific settings are handled using environment variables or `appsettings.{Environment}.json` files.

---

## 4. Verify the Data Layer

In `Bookstore.Data`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider) is referenced and up to date.
- The `DbContext` is registered correctly in the dependency injection container within `Bookstore.Web`.
- Any existing migrations are present and valid. Run the following to check migration status:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application URL shown in the console output (typically `https://localhost:{port}`).
- Test core functionality such as browsing, searching, and any data-driven pages to confirm the data layer is connected and functioning.
- Check the console and application logs for any runtime exceptions.

---

## 6. Run Existing Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests. Failures may indicate runtime behavioral differences between .NET Framework and modern .NET that were not caught at compile time, such as changes in serialization, globalization defaults, or HTTP pipeline behavior.

---

## 7. Validate Platform-Specific Code

Search the codebase for APIs that were available in .NET Framework but may behave differently or require alternatives in cross-platform .NET:

- `System.Web` references — these should have been removed. Confirm none remain.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usage — ensure these reference `Microsoft.AspNetCore.Http` types, not `System.Web` types.
- Any use of the Windows registry, Windows-specific file paths, or COM interop should be reviewed if the application is intended to run on non-Windows platforms.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` folder include all required assemblies, static assets, and configuration files before deploying to the target environment.