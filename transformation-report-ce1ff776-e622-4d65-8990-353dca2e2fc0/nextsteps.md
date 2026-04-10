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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their NuGet pages for recommended replacements compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility, as these may indicate areas that could cause runtime issues.

---

## 3. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) in `Bookstore.Web` to confirm the following:

- Connection strings are valid and point to the correct database instances.
- Any configuration keys previously stored in `Web.config` or `App.config` have been correctly migrated to the new `appsettings.json` format.
- Environment variables or secrets that were previously handled by the legacy project are accounted for.

---

## 4. Verify Entity Framework Migrations

If `Bookstore.Data` uses Entity Framework, verify that migrations are intact and compatible with the new runtime.

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the database schema needs to be updated, apply migrations against your development database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, managing inventory, or any other core functionality, to confirm expected behavior.

---

## 6. Execute Unit and Integration Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests carefully. Failures may point to behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

---

## 7. Check for Platform-Specific API Usage

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to scan for any remaining platform-specific API calls that may not behave correctly on non-Windows operating systems, if cross-platform execution is a goal.

```bash
dotnet tool install -g dotnet-analyze
```

Pay particular attention to:

- File path handling (use `Path.Combine` rather than hardcoded separators).
- Registry access, which is Windows-only.
- Windows-specific authentication or identity APIs.

---

## 8. Publish the Application

Once validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, views, and static files are present before deploying to the target environment.