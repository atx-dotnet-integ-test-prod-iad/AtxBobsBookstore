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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the target framework you are using (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly:
- **Nullable reference type warnings** – These are common after migration and may indicate areas where null-safety logic needs to be reviewed.
- **Obsolete API warnings** – Some APIs used in the legacy project may be marked obsolete in modern .NET. Review and replace them with their recommended alternatives.

---

## 3. Review Configuration Files

Cross-platform .NET projects use `appsettings.json` instead of `Web.config` or `App.config`. Verify the following:

- `appsettings.json` and `appsettings.{Environment}.json` exist in `Bookstore.Web` and contain the correct configuration values (connection strings, logging settings, etc.).
- Any connection strings previously in `Web.config` have been moved to `appsettings.json` under the `ConnectionStrings` section.
- The `Bookstore.Data` project is reading connection strings using `IConfiguration` rather than `ConfigurationManager`.

---

## 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is the data access project, confirm the following:

- If using **Entity Framework Core**, verify that the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If using **EF6**, be aware that EF6 has limited support on cross-platform .NET. Consider migrating to EF Core if full cross-platform support is required.

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at runtime:
- The application starts without exceptions in the console output.
- Database connectivity is established (check logs for connection errors).
- Core application routes and pages load correctly in a browser.

---

## 6. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

Review test output for:
- Any failing tests that may indicate behavioral differences between the legacy .NET Framework version and the new cross-platform .NET version.
- Tests that rely on `HttpContext`, `System.Web`, or other APIs that were replaced during migration — these may need to be updated to use their ASP.NET Core equivalents.

---

## 7. Validate Cross-Platform Behavior (If Applicable)

If the intent is to run the application on Linux or macOS, verify the following:

- **File paths** — Ensure no hardcoded Windows-style paths (e.g., `C:\`) exist in configuration or code. Use `Path.Combine` for path construction.
- **Case sensitivity** — Linux file systems are case-sensitive. Verify that file references, view names, and static asset paths use consistent casing.
- **Windows-specific APIs** — Search the codebase for any remaining usage of Windows-only APIs (e.g., `System.Drawing`, `Microsoft.Win32`, registry access) and replace or conditionally compile them.

---

## 8. Review Startup and Middleware Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to confirm:

- Middleware is registered in the correct order (e.g., `UseAuthentication` before `UseAuthorization`).
- Services registered in the legacy `Global.asax` or `Startup.cs` have been properly moved to the `builder.Services` registration block.
- Static files, routing, and error handling middleware are configured appropriately for a production environment.