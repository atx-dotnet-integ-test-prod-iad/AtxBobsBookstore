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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Configuration

Check the following configuration files for correctness in the context of cross-platform .NET:

- **`appsettings.json`** – Ensure connection strings, API keys, and environment-specific settings are properly defined.
- **`Program.cs`** / **`Startup.cs`** – Confirm the application host and middleware pipeline are configured correctly for ASP.NET Core.
- **`Bookstore.Data` project** – Verify that the database context and any Entity Framework Core migrations are compatible with the target database provider.

If the project previously used `Web.config` or `App.config`, confirm that those settings have been migrated to `appsettings.json` or environment variables.

---

## 4. Run Entity Framework Core Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and can be applied to the target database.

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Apply the migrations to the database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web
```

Navigate to the URL printed in the console output (typically `http://localhost:5000` or `https://localhost:5001`) and verify that the application loads and functions as expected.

---

## 6. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed during the migration.

```bash
dotnet test
```

Review test output for any failures. Pay particular attention to tests that interact with data access, external services, or platform-specific APIs, as these areas are most likely to be affected by a cross-platform migration.

---

## 7. Cross-Platform Validation

If the application is intended to run on non-Windows platforms, test it explicitly on the target operating system (Linux or macOS). Areas to check include:

- **File path handling** – Ensure no hardcoded Windows-style paths (`\`) exist; use `Path.Combine` instead.
- **Case sensitivity** – Linux file systems are case-sensitive. Verify that file references, view names, and static asset paths use consistent casing.
- **Windows-specific APIs** – Confirm that no calls to Windows-only APIs (e.g., the registry, certain `System.Drawing` methods) remain in the codebase.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.