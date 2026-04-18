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

Review the output for any warnings about deprecated or unlisted packages that may need to be updated to versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility, as these can indicate subtle issues that may surface at runtime.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- The database connection strings in your configuration files (e.g., `appsettings.json`) are correct and accessible from the new runtime environment.
- If Entity Framework Core is in use, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add PostMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and manually verify that core functionality works as expected.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas specifically:
- Application startup completes without exceptions.
- All routes and pages load correctly.
- Data reads and writes function as expected against the database.
- Any authentication or authorization mechanisms behave correctly.

Review the console output and application logs for runtime exceptions or deprecation warnings.

---

## 6. Review Configuration Files

Cross-platform .NET no longer relies on `Web.config` or `App.config` in the same way as .NET Framework. Confirm that:

- All configuration has been moved to `appsettings.json` or environment variables.
- Any `Web.config` transforms or `system.web` settings have been replaced with their ASP.NET Core equivalents in `Program.cs` or `Startup.cs`.
- Connection strings, API keys, and other environment-specific values are not hardcoded.

---

## 7. Check for Platform-Specific API Usage

Run the .NET Compatibility Analyzer or review the code manually for any APIs that may have been available in .NET Framework but behave differently or are unavailable in cross-platform .NET.

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Pay particular attention to:
- `System.Web` references, which are not available in cross-platform .NET.
- Windows-specific APIs such as the registry or Windows identity APIs.
- Any third-party libraries that may not have cross-platform support.

---

## 8. Publish the Application

Once validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application runs correctly from the published output before deploying to the target environment.