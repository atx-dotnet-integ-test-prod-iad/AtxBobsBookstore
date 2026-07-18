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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are present, consider replacing them with their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings (e.g., APIs marked with `[SupportedOSPlatform]`)

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config` (connection strings, app settings, etc.).
- `appsettings.Development.json` is present and contains environment-specific overrides.
- Any `<connectionStrings>` or `<appSettings>` entries from the old `Web.config` have been migrated to `appsettings.json`.

---

## 4. Verify the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to a version compatible with cross-platform .NET.
- If using Entity Framework Core, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

- Apply migrations against a development database to confirm schema compatibility:

```bash
dotnet ef database update --project app/Bookstore.Data
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, managing inventory, etc.).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Execute Existing Tests

If the solution contains a test project, run all tests to confirm existing functionality is preserved:

```bash
dotnet test
```

Review the test results for any failures. Pay particular attention to:
- Tests that rely on file paths (Windows-style paths may fail on Linux/macOS).
- Tests that depend on `HttpContext` or ASP.NET-specific infrastructure that may have changed between frameworks.

---

## 7. Validate Cross-Platform Behavior

Since the goal is cross-platform compatibility, test the application on at least one non-Windows environment if possible. Common issues to check for include:

- **File path separators**: Replace hardcoded `\` with `Path.Combine` or `Path.DirectorySeparatorChar`.
- **Case-sensitive file systems**: Linux file systems are case-sensitive; verify that file references (views, static files, etc.) use consistent casing.
- **Windows-only APIs**: Search the codebase for any remaining usage of Windows Registry, COM interop, or other Windows-specific APIs.

---

## 8. Review Deprecated or Removed APIs

Use the .NET Upgrade Analyzer or the compatibility suppressor output to identify any APIs that were available in .NET Framework but have changed behavior or been removed in cross-platform .NET:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Address any `CA1416` (platform compatibility) or similar analyzer warnings before considering the migration complete.