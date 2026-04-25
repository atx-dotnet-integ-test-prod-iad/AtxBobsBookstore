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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay attention to any warnings about obsolete APIs, as these may indicate areas that need further attention even if they do not block the build.

---

## 3. Review Configuration Files

Check the following configuration concerns specific to cross-platform .NET:

- **`appsettings.json`**: Confirm that connection strings and other environment-specific settings have been migrated from `Web.config` or `App.config` if those were present in the original project.
- **`Program.cs` / `Startup.cs`**: Verify that middleware, dependency injection registrations, and service configurations are correct for the target .NET version.
- **Environment variables**: Any settings previously stored in `Web.config` transforms (e.g., `Web.Release.config`) should now be handled via `appsettings.{Environment}.json` or environment variables.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, confirm the data layer is functioning as expected:

- If Entity Framework is used, verify that the `DbContext` configuration is correct and that migrations are up to date.

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

- If the database schema needs to be updated, apply pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data
```

- Confirm that the connection string in `appsettings.json` points to the correct database instance.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate that business logic and data access behavior are preserved after migration.

```bash
dotnet test
```

Review the test results for any failures. Failures at this stage may indicate behavioral differences between the original .NET Framework implementation and the new cross-platform .NET runtime, such as changes in:

- Serialization behavior
- Globalization and culture handling
- File path handling (case sensitivity on Linux/macOS)

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without runtime exceptions.
- Core user-facing pages and features load correctly.
- Database read and write operations function as expected.
- Any authentication or authorization flows work correctly.

---

## 7. Check for Platform-Specific Issues

Since this is a cross-platform migration, test the application on the target operating system if it differs from your development machine. Common issues to look for include:

- **File paths**: Ensure no hardcoded backslash (`\`) path separators exist; use `Path.Combine()` instead.
- **Case sensitivity**: On Linux, file and directory names are case-sensitive. Verify that static file references and view names use consistent casing.
- **Windows-specific APIs**: Search the codebase for any remaining usage of APIs that are not supported on non-Windows platforms, such as certain `System.Drawing` methods or Windows registry access.

---

## 8. Review Deprecated or Removed APIs

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tooling to identify any API usage that may behave differently or be unsupported in the target framework version.

```bash
dotnet tool install -g dotnet-apicompat
```

Address any flagged APIs before considering the migration complete.