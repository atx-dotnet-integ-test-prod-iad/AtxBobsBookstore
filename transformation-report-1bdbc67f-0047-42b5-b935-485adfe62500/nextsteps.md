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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify that existing functionality is preserved after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing basic tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, it likely uses Entity Framework Core or a similar ORM. Verify the following:

- The connection string in `appsettings.json` (or `appsettings.Development.json`) is correctly configured for your target database.
- If using Entity Framework Core, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If there are pending migrations or if the migration history needs to be reconciled, run:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that:

- Pages load without errors
- Data is read from and written to the database correctly
- Any authentication or authorization flows behave as expected

Check the console output and application logs for any runtime exceptions or deprecation warnings.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm the following:

- All configuration values previously in `Web.config` have been moved to `appsettings.json`
- Environment-specific settings are placed in `appsettings.{Environment}.json`
- Secrets such as connection strings are not hardcoded and are managed via environment variables or the .NET Secret Manager:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string" --project Bookstore.Web
```

---

## 7. Check for Platform-Specific API Usage

Even without build errors, some APIs that compiled successfully may not behave correctly on non-Windows platforms. Review the codebase for usage of:

- `System.Drawing` (GDI+ is not fully supported cross-platform)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- `HttpContext.Current` (not available in ASP.NET Core)

Use `Path.Combine` and `Path.DirectorySeparatorChar` for file path handling to ensure cross-platform compatibility.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, views, and configuration files are present before deploying to your target environment.