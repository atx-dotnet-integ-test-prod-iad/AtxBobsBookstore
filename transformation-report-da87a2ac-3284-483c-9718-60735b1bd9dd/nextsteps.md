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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check for updated versions on [NuGet.org](https://www.nuget.org) and update the relevant `.csproj` files accordingly.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to:

- Any `#pragma warning` suppressions that may be hiding real issues.
- Nullable reference type warnings if the project has opted into nullable context.
- Any platform-specific APIs that may have been silently included but will fail at runtime on non-Windows platforms.

---

## 3. Check for Platform-Specific Code

Since this was a legacy project migration, review the codebase for any remaining Windows-specific dependencies that may compile successfully but fail at runtime on Linux or macOS. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or **Windows Identity** APIs
- **File path separators** — ensure `Path.Combine` is used rather than hardcoded backslashes
- **`System.Drawing`** — if used, consider replacing with a cross-platform alternative such as `SkiaSharp` or `ImageSharp`
- **Connection strings** in `appsettings.json` — confirm they are environment-appropriate and not hardcoded for a Windows SQL Server instance

---

## 4. Review Configuration Files

Confirm that the following configuration concerns are addressed:

- `appsettings.json` and `appsettings.Development.json` exist and contain valid configuration.
- Any configuration that was previously in `Web.config` has been properly migrated to `appsettings.json` or the ASP.NET Core middleware pipeline in `Program.cs` / `Startup.cs`.
- Connection strings reference the correct database provider and format for .NET.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and verify:

- The application loads without runtime exceptions.
- Core user-facing pages render correctly.
- Database connectivity is functional (if applicable).

---

## 6. Run Existing Tests

If the solution contains test projects, execute them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results and address any failing tests before proceeding. If no test projects exist, consider adding unit tests for the core logic in `Bookstore.Domain` and integration tests for `Bookstore.Data` to establish a baseline.

---

## 7. Verify Database Migrations (If Using Entity Framework Core)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and can be applied cleanly.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations to a development database to confirm they execute without errors.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once the application has been validated locally, produce a published output for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present, including static assets and configuration files.

Deploy the contents of the `./publish` directory to your target hosting environment according to that environment's standard process for hosting ASP.NET Core applications.