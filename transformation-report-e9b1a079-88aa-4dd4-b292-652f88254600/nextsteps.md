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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to their latest stable versions using:

```bash
dotnet list package --outdated
dotnet add package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48`, `netcoreapp3.1`, or `net6.0`, update the target framework accordingly.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no remaining dependencies rely on Windows-only APIs. Run the compatibility analyzer:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Alternatively, use the .NET Upgrade Assistant or inspect the code manually for usages of `System.Web`, `HttpContext` (classic), `WebForms`, or Windows Registry APIs, which are not available cross-platform.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql` for PostgreSQL).
- Migrations are present and up to date.

Apply migrations against a local or development database to verify correctness:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If no migrations exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to verify that business logic and data access behavior are intact after migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether failures are due to migration issues or pre-existing defects.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality through a browser.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas manually:

- Application startup with no unhandled exceptions
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Static file serving (CSS, JS, images)
- Routing and page rendering

---

## 8. Review Configuration Files

Ensure `appsettings.json` and `appsettings.Development.json` are correctly configured. Legacy projects may have relied on `Web.config` or `App.config`, which are not used in the same way in modern .NET.

- Connection strings should be in `appsettings.json` under `"ConnectionStrings"`.
- Environment-specific settings should use the appropriate `appsettings.{Environment}.json` file.
- Sensitive values such as API keys or passwords should be managed using the .NET Secret Manager during development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 9. Validate Middleware and Startup Configuration

In modern .NET, application configuration is handled in `Program.cs`. Review this file to confirm:

- Middleware is registered in the correct order (e.g., `UseAuthentication` before `UseAuthorization`).
- Services are correctly registered in the dependency injection container.
- Any legacy `Startup.cs` patterns have been consolidated into `Program.cs` if targeting .NET 6 or later.

---

## 10. Publish the Application

Once all validation steps pass, publish the application to confirm the output is complete and self-contained.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and static assets are present before deploying to the target environment.