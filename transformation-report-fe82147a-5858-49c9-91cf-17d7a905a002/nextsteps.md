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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether the failure is due to a migration-related behavioral change or a pre-existing issue.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm that the database connection still functions correctly in the new environment:

- Check that the connection string in `appsettings.json` (or equivalent configuration file) is valid for the target environment.
- If Entity Framework Core is in use, run the following to verify migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are pending, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to perform manual validation of core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that key pages and features load and behave correctly, including any data-driven pages that rely on `Bookstore.Data` and `Bookstore.Domain`.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently from legacy .NET Framework projects. Verify the following:

- `Web.config` transformations are no longer applicable. Confirm that all necessary settings have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Any environment-specific settings (e.g., connection strings, API keys) are correctly configured for the target deployment environment.
- Authentication and authorization middleware, if present, has been correctly configured in `Program.cs` or `Startup.cs`.

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but may behave differently or require alternative implementations in cross-platform .NET:

- `System.Web` references should have been removed or replaced.
- Any use of the Windows Registry, COM interop, or Windows-specific libraries should be identified and assessed for compatibility in the target deployment environment.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.