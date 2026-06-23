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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to:

- Any `NETSDK` warnings about target framework compatibility
- Obsolete API usage warnings that may indicate areas needing further modernization

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- `appsettings.json` exists in `Bookstore.Web` and contains the correct configuration values (connection strings, app settings, etc.)
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate
- If Entity Framework is used in `Bookstore.Data`, verify the connection string is correctly referenced via `IConfiguration`

---

## 4. Verify the Data Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework Core is in use, run a check to ensure migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- If there are pending migrations or the database schema needs to be applied:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
dotnet run --project app/Bookstore.Web --configuration Development
```

- Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`)
- Test core application flows such as browsing, searching, and any data entry forms
- Check the console and browser developer tools for runtime errors or unhandled exceptions

---

## 6. Execute Unit and Integration Tests

If the solution contains test projects, run all tests to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results for any failures. If tests were written against .NET Framework-specific APIs that no longer exist, those tests will need to be updated to use their .NET equivalents.

---

## 7. Inspect Middleware and HTTP Pipeline

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) to confirm the middleware pipeline is correctly configured for cross-platform .NET:

- Ensure `UseStaticFiles`, `UseRouting`, `UseAuthentication`, `UseAuthorization`, and `UseEndpoints` (or their minimal API equivalents) are called in the correct order
- Confirm that any custom HTTP modules or handlers from the legacy project have been replaced with the equivalent ASP.NET Core middleware

---

## 8. Validate Static Assets and Views

- Confirm that static files (CSS, JavaScript, images) are located under the `wwwroot` folder in `Bookstore.Web`
- If Razor Views are used, verify they render correctly at runtime
- If Bundling and Minification was previously handled by `System.Web.Optimization`, confirm it has been replaced with a supported alternative such as `BundleMinifier` or a front-end build tool

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, including `appsettings.json` and any static assets.