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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that may surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations are up to date and compatible with the target database:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations are out of date or missing, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Apply the migrations to the database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to verify it runs correctly in the new cross-platform environment:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the URL shown in the terminal output and manually verify that core pages and functionality load as expected.

---

## 6. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) in `Bookstore.Web` for the following:

- Connection strings are correct for the target environment.
- Any Windows-specific paths or registry-based configuration have been replaced with cross-platform equivalents.
- Authentication or session settings are valid for ASP.NET Core.

---

## 7. Check for Platform-Specific Code

Search the codebase for any remaining APIs or patterns that may not behave consistently across platforms:

- `System.Web` references (should have been replaced by ASP.NET Core equivalents)
- Windows-specific file path separators (use `Path.Combine` instead of hardcoded `\`)
- `HttpContext.Current` usage (not available in ASP.NET Core)
- `ConfigurationManager` usage (should be replaced with `IConfiguration`)

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present before deploying to the target environment.