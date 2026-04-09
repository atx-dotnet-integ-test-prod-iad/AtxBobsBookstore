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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it is using the appropriate web SDK:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
```

---

## 4. Check Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- If the original project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to `appsettings.json` or the appropriate .NET configuration system.
- Ensure that `Program.cs` and `Startup.cs` (if applicable) are correctly configured for the middleware pipeline, dependency injection, and service registration.

---

## 5. Database and Data Layer Validation

- If the project uses Entity Framework, confirm the correct version of EF Core is referenced in `Bookstore.Data`.
- Run any pending migrations to ensure the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, managing inventory, or any other core features, to confirm they function as expected.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior:

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral regressions introduced during the migration.

---

## 8. Review Platform-Specific Code

Search the codebase for any APIs or libraries that were specific to Windows or .NET Framework and may not behave identically on cross-platform .NET:

- `System.Web` references (should be fully replaced by ASP.NET Core equivalents)
- Windows Registry access
- COM interop
- `HttpContext.Current` usage (replaced by dependency-injected `IHttpContextAccessor`)
- `Thread.Abort` (not supported in .NET 5+)

Address any remaining usages before considering the migration complete.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application starts correctly from the published output.