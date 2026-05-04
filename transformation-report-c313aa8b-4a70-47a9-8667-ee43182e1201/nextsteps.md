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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. If tests were written against .NET Framework-specific behaviors (e.g., `HttpContext`, `ConfigurationManager`), they may require updates to work correctly under cross-platform .NET.

---

## 4. Verify Runtime Behavior

### 4.1 Database Connectivity

Since the solution includes a `Bookstore.Data` project, verify that the data layer connects correctly to the target database:

- Confirm that the connection string in `appsettings.json` (or equivalent) is correctly configured for the target environment.
- If Entity Framework is used, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 4.2 Run the Web Application Locally

Start the web application and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test the primary user-facing features, such as browsing, searching, and any data entry forms.

---

## 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` instead of `Web.config` or `App.config`. Confirm the following:

- All connection strings have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Production.json` or managed via environment variables.
- Any `Web.config` transforms or `system.web` configurations that were present in the original project have been accounted for or replaced with their ASP.NET Core equivalents.

---

## 6. Check for Platform-Specific API Usage

Run the .NET Compatibility Analyzer to identify any remaining calls to Windows-specific or otherwise unsupported APIs:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Pay particular attention to any `CA1416` (platform compatibility) warnings, which indicate APIs that may not function correctly on Linux or macOS.

---

## 7. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application starts correctly from that output.