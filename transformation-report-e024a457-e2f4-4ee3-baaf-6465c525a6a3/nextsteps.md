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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that are compatible with the current .NET target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET projects handle configuration differently than legacy .NET Framework projects. Verify the following:

- `appsettings.json` is present in `Bookstore.Web` and contains the correct connection strings and application settings.
- Any configuration that was previously in `Web.config` or `App.config` has been migrated to `appsettings.json` or the appropriate .NET configuration provider.
- Environment-specific configuration files (e.g., `appsettings.Development.json`) are in place if needed.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, confirm the following:

- The database provider package (e.g., Entity Framework Core with SQL Server, SQLite, etc.) is correctly referenced in `Bookstore.Data.csproj`.
- The `DbContext` is properly configured in the dependency injection setup within `Bookstore.Web`.
- Any database migrations are present and up to date. Run the following to check migration status:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Then apply the migration to the database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and verify that the application loads and core functionality is working as expected.

---

## 6. Execute Unit Tests

If the solution contains test projects, run them to verify that existing logic behaves correctly after the migration.

```bash
dotnet test
```

Review the test results for any failures. Failures may indicate runtime behavioral differences between the legacy .NET Framework and the current .NET version that were not caught at compile time.

---

## 7. Check for Platform-Specific API Usage

Even with a clean build, some APIs that were available in .NET Framework may behave differently or have reduced functionality in cross-platform .NET. Areas to review manually include:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET. These should have been replaced with ASP.NET Core equivalents.
- Any use of the Windows registry, COM interop, or Windows-specific libraries.
- `HttpContext` usage patterns, which differ between ASP.NET and ASP.NET Core.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining compatibility concerns:

```bash
dotnet tool install -g dotnet-apicompat
```

---

## 8. Validate Static Assets and Razor Views

If `Bookstore.Web` uses Razor views or static assets, confirm the following:

- All `.cshtml` files render correctly at runtime.
- Static files (CSS, JavaScript, images) are located under the `wwwroot` folder and are being served correctly.
- Tag helpers and view components function as expected under ASP.NET Core conventions.