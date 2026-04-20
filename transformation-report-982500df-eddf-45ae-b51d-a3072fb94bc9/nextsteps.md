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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas where the code may behave differently under .NET compared to the legacy framework.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- **Database provider**: Ensure the correct EF Core provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, or `Sqlite`) is referenced and configured in the project.
- **Migrations**: If Entity Framework Core is used, verify that existing migrations are intact and apply them against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- **Connection strings**: Confirm that connection strings in `appsettings.json` are correct for the target environment.

---

## 5. Validate Web Application Startup

Run the web application locally and verify it starts without errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts and listens on the expected port.
- All routes resolve correctly.
- Static assets load as expected.
- Any middleware configured in `Program.cs` or `Startup.cs` is functioning correctly.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently from legacy .NET Framework. Verify the following:

- `appsettings.json` and `appsettings.{Environment}.json` contain all necessary settings previously held in `Web.config` or `App.config`.
- Any environment-specific settings (e.g., connection strings, API keys) are correctly placed and not hardcoded.
- The `ASPNETCORE_ENVIRONMENT` environment variable is set appropriately for local development (typically `Development`).

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but are absent or behave differently in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in .NET Core or later.
- Windows-specific APIs such as the registry, WCF server-side components, or `System.Drawing` (use `System.Drawing.Common` with awareness of its platform limitations).
- Any use of `HttpContext` that may need to be updated to use `IHttpContextAccessor`.

---

## 8. Test Against Target Runtime

If the application is intended to run on Linux or macOS in addition to Windows, perform a test run on the target operating system to catch any remaining platform-specific issues, particularly around file path handling (case sensitivity) and OS-level dependencies.