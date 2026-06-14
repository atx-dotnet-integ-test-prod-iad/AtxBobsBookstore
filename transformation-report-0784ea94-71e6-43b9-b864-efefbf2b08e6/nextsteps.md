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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to their latest versions that support the current .NET target.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to:
- Any nullable reference type warnings introduced by the new SDK
- Obsolete API usages that may have been flagged during the migration

---

## 3. Review Configuration Files

Check that `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) in `Bookstore.Web` are correctly configured. Specifically verify:

- **Connection strings** are valid and point to the correct database
- **Logging** settings are appropriate for each environment
- Any settings previously stored in `Web.config` or `App.config` have been correctly migrated to the new configuration system

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that the data access layer is functioning correctly:

- If using **Entity Framework Core**, ensure migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If using a different ORM or raw ADO.NET, manually verify that connection handling and query execution work against the target database.

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify:
- The home page loads correctly
- Core user flows (e.g., browsing books, adding to cart, checkout) function as expected
- No unhandled exceptions appear in the console output or logs

---

## 6. Execute Existing Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review the test results for any failures. Failures may indicate behavioral differences introduced by the migration to the new .NET runtime. Address any failing tests before proceeding to deployment.

If no test projects currently exist, consider adding unit tests for critical paths in `Bookstore.Domain` and integration tests for `Bookstore.Data`.

---

## 7. Validate Static Assets and Middleware

In `Bookstore.Web`, confirm that:
- Static files (CSS, JavaScript, images) are being served correctly
- Middleware pipeline configuration in `Program.cs` or `Startup.cs` is complete and ordered correctly
- Authentication and authorization, if applicable, are functioning as expected

---

## 8. Publish the Application

Once the application has been validated locally, publish it to prepare for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, including:
- The compiled assemblies
- `appsettings.json`
- Static web assets (`wwwroot`)

---

## 9. Deploy to Target Environment

Copy the published output to your target hosting environment. Depending on your hosting setup:

- **IIS**: Ensure the ASP.NET Core Hosting Bundle is installed and the site is configured to use the correct application pool (No Managed Code).
- **Self-hosted / Kestrel**: Run the application directly using `dotnet Bookstore.Web.dll` and configure a reverse proxy (e.g., IIS or Nginx) in front of it as needed.
- **Linux**: Verify file permissions on the publish directory and confirm the correct .NET runtime version is installed on the target machine.