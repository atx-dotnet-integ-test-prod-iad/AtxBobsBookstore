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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no projects are still referencing `net48` or any other .NET Framework moniker.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before proceeding further.

---

## 5. Validate Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- If Entity Framework Core is used, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a local or staging database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Web Application Locally

Start the web application to verify it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output and manually verify that core pages and features function as expected, including any database-driven content.

---

## 7. Review `appsettings.json` and Configuration

Check that all configuration values previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Database connection strings
- Any third-party API keys or service endpoints
- Logging configuration

---

## 8. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or packages that may cause issues on Linux or macOS:

- Use of `Microsoft.Win32` namespaces
- Registry access
- Windows-only file path assumptions (e.g., hardcoded backslashes)

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present.