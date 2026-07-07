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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET release schedule](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm your chosen version is still under active support.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit the codebase for any APIs or packages that are Windows-only. Common areas to check include:

- `Microsoft.Win32` namespace usage
- Windows Registry access
- COM interop
- `System.Drawing` (which has platform limitations outside of Windows)

Use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist with this audit.

---

## 5. Database and Entity Framework Migrations

If `Bookstore.Data` uses Entity Framework, verify the following:

- The EF Core provider package matches your database (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Existing migrations are compatible with EF Core.
- Run the following to apply migrations against your target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests for the core domain logic in `Bookstore.Domain` before deploying to a production environment.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Confirm the following manually:

- Application starts without runtime exceptions.
- Database connectivity is functional.
- Core user-facing features (browsing, searching, purchasing books) behave as expected.
- Configuration values in `appsettings.json` are correct for the target environment.

---

## 8. Validate Configuration and Secrets

Ensure that `appsettings.json` and environment-specific files such as `appsettings.Production.json` are properly configured. Sensitive values such as connection strings should not be stored in source control. Use one of the following approaches:

- [.NET User Secrets](https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets) for local development.
- Environment variables for production deployments.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets and configuration files are present before deploying to the target environment.