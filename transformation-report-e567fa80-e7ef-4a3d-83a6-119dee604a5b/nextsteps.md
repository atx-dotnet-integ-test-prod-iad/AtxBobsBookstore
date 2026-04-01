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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, it is worth adding tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations are missing or out of date, generate and apply them:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Verify that the connection string in `appsettings.json` (or `appsettings.Development.json`) is correctly configured for your target database.

---

## 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually exercise the key workflows such as browsing, searching, and managing books.

---

## 6. Review Configuration Files

Check the following files in `Bookstore.Web` for any settings that may still reference legacy or environment-specific values:

- `appsettings.json`
- `appsettings.Development.json`
- `Program.cs` (or `Startup.cs` if still present)

Ensure that middleware registration, service configuration, and authentication settings are compatible with the target .NET version.

---

## 7. Validate Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` to avoid cross-framework compatibility issues.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify all required assets, static files, and configuration files are present before deploying to the target environment.