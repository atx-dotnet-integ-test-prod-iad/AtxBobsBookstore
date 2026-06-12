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

Review the output for any warnings related to package compatibility or version conflicts. Address any packages that may have been targeting the old .NET Framework and verify their cross-platform equivalents are in place.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Obsolete API usage
- Nullable reference type warnings
- Platform compatibility warnings (e.g., `CA1416`)

---

## 3. Review Configuration Files

Check that configuration files have been properly migrated:

- Confirm that any `Web.config` or `App.config` values have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Verify that connection strings in `appsettings.json` are correct and point to the intended database.
- Ensure environment-specific settings are handled using the `IConfiguration` interface and not through legacy `ConfigurationManager` calls.

---

## 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, confirm the data layer is functioning correctly:

- If using Entity Framework Core, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- Confirm that the `DbContext` is registered correctly in `Program.cs` or `Startup.cs` using `AddDbContext`.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite to validate business logic and data access behavior:

```bash
dotnet test
```

Review test results and address any failures. Pay particular attention to tests that cover:
- Domain model logic (`Bookstore.Domain`)
- Repository or data access methods (`Bookstore.Data`)
- Controller actions or middleware (`Bookstore.Web`)

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web
```

Manually verify the following:
- The application starts without exceptions.
- Database connectivity is established.
- Core application routes and pages load as expected.
- Any authentication or authorization flows work correctly.

---

## 7. Check for Removed or Changed APIs

Cross-platform .NET does not support certain Windows-specific APIs that were available in .NET Framework. Review the codebase for any usage of:

- `System.Web` namespaces (these are not available in modern .NET)
- `HttpContext` usage outside of the request pipeline
- Windows Registry access
- `System.Drawing` (requires additional packages on non-Windows platforms)

If any such usages are found, replace them with their modern .NET equivalents.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Ensure consistency across all projects unless there is a specific reason for a project to target a different framework.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets, configuration files, and runtime dependencies.