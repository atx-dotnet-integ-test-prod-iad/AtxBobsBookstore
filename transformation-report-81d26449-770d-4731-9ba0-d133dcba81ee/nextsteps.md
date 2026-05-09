# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or warnings that could indicate runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify that existing functionality has not regressed during the migration:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Pay particular attention to:

- Tests covering data access logic in `Bookstore.Data`, as Entity Framework provider behavior can differ between .NET Framework and cross-platform .NET.
- Tests covering domain logic in `Bookstore.Domain`.
- Any integration tests that exercise the full request pipeline in `Bookstore.Web`.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` likely contains data access logic, confirm the following:

- The connection string in your configuration file (`appsettings.json`) is correct for your target environment.
- If Entity Framework Core is being used, verify that all migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- Core user-facing pages load correctly.
- Data is read from and written to the database as expected.
- Any authentication or authorization flows behave correctly.

---

## 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` for most configuration. Confirm that:

- All connection strings have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Production.json` or managed via environment variables.
- Any `Web.config` transforms or `app.config` sections that were relevant to the application have been accounted for.

---

## 7. Check for Platform-Specific API Usage

Even without build errors, there may be runtime issues if any code relies on Windows-specific APIs. Search the codebase for usages such as:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows Registry access
- Windows-specific file path assumptions

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tooling to assist with this check if needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected assets, views, and static files are present.