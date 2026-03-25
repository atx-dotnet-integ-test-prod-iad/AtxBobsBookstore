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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the new target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build output shows zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage warnings
- Platform compatibility warnings (e.g., `CA1416`)

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config`, including connection strings and application settings.
- Any environment-specific overrides are placed in `appsettings.Development.json` or `appsettings.Production.json`.
- Confirm that `Startup.cs` or `Program.cs` correctly reads configuration using `IConfiguration`.

---

## 4. Verify the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to the appropriate cross-platform version (e.g., EF Core instead of EF 6 if applicable).
- Run any pending migrations or verify that the database schema is compatible:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute all tests to validate that existing functionality behaves as expected after the migration.

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral differences introduced by the framework change, such as:
- Changes in middleware pipeline behavior
- Differences in dependency injection registration
- Changes in JSON serialization defaults (e.g., `System.Text.Json` vs `Newtonsoft.Json`)

---

## 6. Run the Application Locally

Start the application locally and verify core functionality manually.

```bash
dotnet run --project Bookstore.Web
```

Check the following areas specifically:
- Application startup completes without exceptions.
- Database connectivity is functional.
- Core user-facing routes and pages load correctly.
- Any authentication or authorization mechanisms behave as expected.

---

## 7. Check for Windows-Specific API Usage

Since this is a cross-platform migration, audit the codebase for any remaining Windows-specific APIs that may not be available on Linux or macOS. Common areas to check include:

- Use of the Windows Registry (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions (backslashes vs. forward slashes)
- `System.Drawing` usage, which requires additional native dependencies on non-Windows platforms (consider replacing with a library such as `SkiaSharp` or `ImageSharp`)

Use the .NET Compatibility Analyzer to assist with this:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 8. Publish the Application

Once validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present.