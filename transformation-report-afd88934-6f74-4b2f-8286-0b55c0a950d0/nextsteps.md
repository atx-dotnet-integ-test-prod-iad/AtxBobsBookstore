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

Review the test results carefully. Any failing tests should be investigated to determine whether the failure is due to the migration or a pre-existing issue.

---

## 4. Verify Entity Framework Core Migrations (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm that migrations are compatible with the new runtime. Run the following to list existing migrations:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the database schema needs to be updated, apply migrations against a development database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Validate Runtime Behavior

Start the web application locally and verify core functionality:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Walk through the primary user-facing features of the application, including:

- Page rendering and navigation
- Database read and write operations
- Any authentication or authorization flows
- Static file serving (CSS, JavaScript, images)

---

## 6. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) are present and correctly configured. Pay particular attention to:

- Connection strings
- Any settings that previously resided in `Web.config` or `App.config`, which may need to be manually migrated to the `appsettings.json` format

---

## 7. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects so there are no cross-targeting conflicts.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assemblies, static files, and configuration files are present before deploying to the target environment.