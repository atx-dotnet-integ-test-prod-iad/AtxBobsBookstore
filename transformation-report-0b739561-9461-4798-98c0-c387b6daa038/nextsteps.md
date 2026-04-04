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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting `net6.0` or `net7.0`, consider updating to `net8.0` as those versions are either end-of-life or approaching it.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, verify that no Windows-only APIs are being used without a compatibility guard. You can use the .NET Compatibility Analyzer for this:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to:
- `System.Web` references (not available in .NET Core/5+)
- Windows Registry access
- COM interop
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the correct version is referenced:

- **Entity Framework Core** should be used instead of the legacy `EntityFramework` (EF6) package.
- Run any pending migrations to verify the database schema is compatible:

```bash
dotnet ef migrations list
dotnet ef database update
```

If EF6 is still in use, evaluate whether migrating to EF Core is feasible for your use case.

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to confirm runtime behavior is consistent with the original application:

```bash
dotnet test --configuration Release --logger trx
```

Review the test results for any failures that may indicate behavioral differences introduced during the migration.

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:
- Authentication and authorization flows
- Database read/write operations
- Any file system interactions (paths may differ across operating systems)
- Static file serving and routing

---

## 8. Review Configuration Files

Legacy projects often rely on `Web.config` or `App.config`. In .NET, configuration is handled via `appsettings.json` and environment variables. Confirm that:

- All connection strings have been moved to `appsettings.json`
- Any environment-specific settings use `appsettings.{Environment}.json`
- Secrets are not stored in source-controlled configuration files; use `dotnet user-secrets` for local development:

```bash
dotnet user-secrets init --project app/Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all necessary files, static assets, and dependencies are present.