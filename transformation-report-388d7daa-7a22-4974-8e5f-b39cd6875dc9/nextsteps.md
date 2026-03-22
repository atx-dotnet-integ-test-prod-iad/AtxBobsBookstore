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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their NuGet pages for recommended replacements compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET projects handle configuration differently from legacy .NET Framework projects.

- Confirm that `appsettings.json` (and `appsettings.Development.json` if applicable) is present in `Bookstore.Web` and contains the correct connection strings and application settings.
- Verify that any settings previously stored in `Web.config` or `App.config` have been migrated to `appsettings.json` or the appropriate .NET configuration provider.
- Check that environment-specific configuration is handled using `IConfiguration` and the standard .NET configuration system.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the data layer is functioning as expected.

- Confirm that Entity Framework Core (or whichever ORM is in use) is correctly configured in `Bookstore.Data`.
- If Entity Framework Core is being used, check that migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- Apply any pending migrations to a local development database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web --configuration Development
```

- Navigate to the displayed local URL in a browser.
- Exercise the primary application flows, such as browsing books, to confirm the domain and data layers are functioning end to end.
- Review the console output for any runtime exceptions or unhandled errors.

---

## 6. Run Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to tests that cover data access or platform-specific behavior, as these are the most likely areas to be affected by a cross-platform migration.

---

## 7. Validate Platform Compatibility

Since the goal is cross-platform support, validate the application on each intended target platform (Windows, Linux, macOS) if possible.

- Run the application on each target OS using `dotnet run` or by publishing a self-contained executable.
- Pay attention to file path handling, as hardcoded backslashes (`\`) in paths will cause issues on Linux and macOS. Use `Path.Combine` or forward slashes where applicable.
- Check for any use of Windows-specific APIs or registry access that may not have been caught during the build phase.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment.

For a framework-dependent deployment:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

For a self-contained deployment targeting a specific runtime (example for Linux x64):

```bash
dotnet publish app/Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.