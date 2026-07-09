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

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may indicate behavioral differences between the legacy .NET Framework version and the new cross-platform .NET version.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, verify the following:

- **Database Migrations**: If Entity Framework Core is in use, confirm that migrations are up to date by running:
  ```bash
  dotnet ef migrations list --project Bookstore.Data
  ```
- **Connection Strings**: Confirm that connection strings in `appsettings.json` (or equivalent configuration files) are correctly configured for the target environment.
- **Database Compatibility**: If the project previously used `System.Data` or older Entity Framework (6.x), confirm that the data access layer has been correctly updated to Entity Framework Core or an equivalent library.

---

## 5. Verify Domain Logic

Review `Bookstore.Domain` for any types or APIs that were available in .NET Framework but may behave differently or require replacements in cross-platform .NET, such as:

- `System.Configuration.ConfigurationManager` (replace with `Microsoft.Extensions.Configuration`)
- Any Windows-specific APIs that may have been silently included

---

## 6. Run and Validate the Web Application

Start the web application locally and perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- All pages and routes load without errors.
- Authentication and authorization flows work as expected.
- Data is correctly read from and written to the database.
- Static assets (CSS, JavaScript, images) are served correctly.
- Review application logs for any runtime exceptions that would not surface at build time.

---

## 7. Check for Removed or Changed APIs

Use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining API usage that is not supported on cross-platform .NET. Run the analyzer as part of the build:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Review and address any diagnostics flagged by the analyzer.

---

## 8. Review Configuration and Environment Settings

- Confirm that `appsettings.json` and `appsettings.{Environment}.json` files contain all settings previously held in `Web.config` or `App.config`.
- Verify that environment-specific settings (e.g., development vs. production) are correctly separated.
- Confirm that any HTTP pipeline configuration previously in `Global.asax` or `Startup.cs` (OWIN) has been correctly migrated to the ASP.NET Core middleware pipeline.

---

## 9. Publish the Application

Once validation is complete, publish the application to the target deployment location:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm that all required files, including configuration files and static assets, are present before deploying to the target server.