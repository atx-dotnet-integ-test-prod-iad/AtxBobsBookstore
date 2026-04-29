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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end-of-life.

---

## 4. Verify Entity Framework or Data Access Layer

Since the solution includes a `Bookstore.Data` project, confirm the following:

- The correct version of Entity Framework Core is referenced (not the legacy `EntityFramework` package).
- Any database migrations are present and up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Check Configuration Files

Verify that `appsettings.json` (and `appsettings.Development.json`) exist in `Bookstore.Web` and contain the correct configuration, including:

- Database connection strings
- Any application-specific settings previously stored in `Web.config` or `App.config`

Legacy `Web.config` settings are not automatically read by .NET. Confirm all necessary configuration values have been migrated to `appsettings.json`.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the displayed local URL and manually verify the following:

- The application loads without exceptions
- Data is retrieved and displayed correctly from the database
- Core user flows (e.g., browsing books, adding to cart, checkout) function as expected

---

## 7. Run Existing Tests

If the solution contains a test project, execute the tests to confirm existing functionality is preserved:

```bash
dotnet test
```

Review the test results for any failures that may indicate regressions introduced during the migration.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.