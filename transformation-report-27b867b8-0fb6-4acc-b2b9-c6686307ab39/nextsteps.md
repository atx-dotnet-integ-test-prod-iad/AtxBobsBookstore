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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. If tests were written against .NET Framework-specific behaviors, some may require updates to align with cross-platform .NET semantics.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- The connection strings in your configuration files (e.g., `appsettings.json`) are correct and accessible from the new runtime environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate and apply them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the `Bookstore.Web` project locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, placing orders).
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that static assets (CSS, JavaScript, images) are served correctly.

---

## 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` instead of `Web.config` or `App.config`. Confirm the following:

- All connection strings have been migrated to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate.
- Any `Web.config` transforms or `App.config` sections that were previously in use have been accounted for.

---

## 7. Validate Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but behave differently or are unavailable in cross-platform .NET. Common areas to check include:

- `System.Web` references — these are not available in cross-platform .NET and should have been replaced during transformation.
- Windows Registry access (`Microsoft.Win32.Registry`) — this will not function on non-Windows platforms.
- File path separators — use `Path.Combine` and `Path.DirectorySeparatorChar` rather than hardcoded backslashes.
- `AppDomain` usage — some members are no longer supported.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, assemblies, and static assets are present before deploying to your target environment.