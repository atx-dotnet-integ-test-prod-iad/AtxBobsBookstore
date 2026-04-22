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

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test output for any failures. Pay close attention to tests that cover data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by framework differences.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely depends on a database, verify the following:

- **Connection strings** in `appsettings.json` or `appsettings.Production.json` are correctly configured for the target environment.
- If Entity Framework Core is used, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to verify it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the URL shown in the console output.
- Test core user-facing functionality such as browsing, searching, and any authentication flows.
- Check the console and browser developer tools for runtime errors or missing static assets.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently from legacy .NET Framework projects. Verify the following in `Bookstore.Web`:

- `appsettings.json` contains all settings previously held in `Web.config` or `App.config`.
- Any environment-specific overrides are placed in `appsettings.Development.json` or `appsettings.Production.json`.
- Middleware configuration in `Program.cs` or `Startup.cs` correctly registers services such as authentication, authorization, and database contexts.

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but behave differently or are unavailable in cross-platform .NET:

- `System.Web` references should have been fully removed or replaced.
- Any use of the Windows registry, COM interop, or Windows-specific libraries should be identified and replaced with cross-platform alternatives if the application is intended to run on non-Windows systems.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining platform-specific dependencies.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.