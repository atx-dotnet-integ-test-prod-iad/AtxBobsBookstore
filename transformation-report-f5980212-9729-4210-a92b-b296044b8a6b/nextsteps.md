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

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test output carefully. Any failing tests may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- The connection strings in `appsettings.json` (or equivalent configuration) are correctly set for the target environment.
- Entity Framework Core migrations (if applicable) are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of date or missing, generate and apply them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to verify it runs correctly on the cross-platform runtime:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify core functionality such as:

- Page rendering
- Data retrieval and display
- Form submissions
- Authentication and authorization flows, if present

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm that:

- All settings previously in `Web.config` or `App.config` have been moved to `appsettings.json`.
- Environment-specific configuration is handled via `appsettings.{Environment}.json` or environment variables.
- Any `<system.web>` or `<httpModules>` configuration has been replaced with the appropriate ASP.NET Core middleware in `Program.cs` or `Startup.cs`.

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that may have been available in .NET Framework but behave differently or are unavailable in cross-platform .NET. Common areas to check include:

- `System.Web` references (should no longer be present)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) client or server usage
- `AppDomain` usage beyond what is supported in .NET Core and later

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tooling to assist with this review if needed.

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets, configuration files, and binaries are present before deploying to the target environment.