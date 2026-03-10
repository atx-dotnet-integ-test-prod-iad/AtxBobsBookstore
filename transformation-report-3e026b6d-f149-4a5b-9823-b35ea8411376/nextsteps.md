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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may indicate behavioral regressions introduced during the migration.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) migrations are compatible with the new target framework.
- If the project uses EF Core, verify that the database context and migrations are intact by running:

```bash
dotnet ef migrations list
```

- If the project previously used EF 6 and was migrated to EF Core, manually review the `DbContext`, entity configurations, and any raw SQL queries for compatibility differences.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models and business logic classes for any reliance on APIs that are no longer available or have changed behavior in modern .NET.
- Check for any use of `System.Web` or other Windows-specific namespaces that may have been removed or replaced during transformation.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- If the project was migrated from ASP.NET (System.Web) to ASP.NET Core, verify the following:
  - `Program.cs` and `Startup.cs` (or the combined `Program.cs` in .NET 6+) are correctly configured.
  - Middleware pipeline is properly set up (authentication, routing, static files, etc.).
  - Configuration is being read from `appsettings.json` rather than `Web.config` where applicable.
  - Any `Global.asax` logic has been moved to the appropriate ASP.NET Core equivalents.
- Run the web application locally:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate to the application in a browser and manually verify core functionality such as page rendering, navigation, and data access.

---

## 7. Review Configuration Files

- Ensure `appsettings.json` contains the correct connection strings and application settings previously held in `Web.config` or `App.config`.
- Confirm that environment-specific configuration (e.g., `appsettings.Development.json`) is in place where needed.

---

## 8. Check for Platform-Specific Code

- Search the codebase for any remaining Windows-specific APIs (e.g., registry access, `System.Web`, COM interop) that may not function correctly on non-Windows platforms if cross-platform support is a requirement.
- Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining platform-specific dependencies.

---

## 9. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the output directory to confirm all required files are present before deploying to the target environment.