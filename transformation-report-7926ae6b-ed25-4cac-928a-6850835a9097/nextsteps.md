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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Run Existing Tests

If the solution contains a test project, execute the test suite to confirm that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release
```

Review the test results for any failures. Pay particular attention to tests that cover:

- Data access logic in `Bookstore.Data`
- Domain model behavior in `Bookstore.Domain`
- HTTP request handling and routing in `Bookstore.Web`

If no test project currently exists, consider adding unit tests for the core domain and data layers as a baseline for future changes.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that any existing migrations are compatible with the migrated project.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the migrations list is returned without errors, apply them to a development database to verify schema correctness.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Check that the connection string in `appsettings.json` (or `appsettings.Development.json`) is correctly configured for the target environment.

---

## 5. Run the Application Locally

Start the web application locally and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Confirm the following at a minimum:

- The application starts without runtime exceptions.
- Key pages or API endpoints load and return expected data.
- Any authentication or authorization flows work as intended.
- Static assets (CSS, JavaScript, images) are served correctly.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently from legacy .NET Framework projects. Review the following:

- Ensure `appsettings.json` contains all settings previously held in `Web.config` or `App.config`.
- Confirm that environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate.
- Verify that any file paths used in the application use `Path.Combine` or forward-slash-compatible formats to ensure cross-platform compatibility.

---

## 7. Check for Platform-Specific API Usage

Even without build errors, the code may reference APIs that behave differently or are unavailable on non-Windows platforms. Use the .NET Compatibility Analyzer to surface any such issues.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Address any platform compatibility warnings that are relevant to your target deployment operating system.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including configuration files and static assets.