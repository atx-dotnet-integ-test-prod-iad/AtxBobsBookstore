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

Review the output for any warnings related to package compatibility or version conflicts. Address any packages that may have been targeting the old .NET Framework and verify their cross-platform equivalents are in place.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build output reports zero errors and review any warnings, particularly those related to deprecated APIs or obsolete members that may have been carried over from the legacy project.

---

## 3. Review Configuration Files

- Confirm that `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- If the legacy project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to the appropriate `appsettings.json` structure.
- Check that any environment variables or secrets previously stored in `Web.config` transforms are now handled via `appsettings.json`, user secrets, or environment variables.

---

## 4. Verify Database Connectivity

Since the solution contains a `Bookstore.Data` project, confirm that the data layer is functioning correctly.

- Verify the connection string in `appsettings.json` points to the correct database instance.
- If Entity Framework is in use, check that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary user flows (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Execute Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to tests that interact with the database or external services, as these may require updated configuration for the new environment.

---

## 7. Validate Cross-Platform Behavior

Since the goal of the transformation was cross-platform compatibility, test the application on a non-Windows environment if possible (Linux or macOS).

- Confirm file path handling does not rely on Windows-specific path separators.
- Confirm there are no remaining references to Windows-only APIs (e.g., the registry, `System.Web`, or Windows-specific authentication providers).
- Run `dotnet build` and `dotnet run` on the target platform to verify consistent behavior.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid compatibility issues between projects in the solution.

---

## 9. Publish the Application

Once validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.