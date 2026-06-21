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

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target a consistent framework version to avoid interoperability issues.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for any APIs or packages that are Windows-only, as these may not have surfaced as build errors but could cause runtime failures on non-Windows platforms. Common areas to check include:

- Use of `Microsoft.Win32` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- Any remaining references to `System.Web`

Use the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Sqlite`)
- Any pending migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project exists, consider writing basic integration tests for the core domain logic in `Bookstore.Domain` and the data access methods in `Bookstore.Data` before proceeding to deployment.

---

## 7. Run the Web Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Confirm the following:

- The application starts without runtime exceptions
- Pages and routes load correctly
- Database connectivity is functional
- Any authentication or session handling works as expected

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Development.json`) are properly configured for the new .NET host model. Verify:

- Connection strings are correct
- Any configuration previously in `Web.config` has been migrated to `appsettings.json`
- Environment-specific settings are handled using the `ASPNETCORE_ENVIRONMENT` variable

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, views, and static files are present before deploying to the target environment.