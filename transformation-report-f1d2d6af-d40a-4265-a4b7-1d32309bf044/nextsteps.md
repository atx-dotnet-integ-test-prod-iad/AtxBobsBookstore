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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors. Address any warnings that could indicate runtime issues, such as nullable reference warnings or obsolete API usage.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for APIs or packages that are Windows-only, such as:

- `Microsoft.Win32` registry access
- `System.Windows.Forms` or `System.Drawing` (without the `EnableUnixSupport` flag)
- Any P/Invoke calls targeting Windows DLLs

If any are found, evaluate whether a cross-platform alternative exists or whether a runtime platform check is needed.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to verify that business logic and data access behavior is preserved after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new .NET runtime.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another ORM, verify the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is compatible with the target framework version.

---

## 7. Run the Web Application Locally

Start the application locally to verify it runs as expected end-to-end.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm functionality is intact. Check the console output and application logs for any runtime exceptions.

---

## 8. Review Configuration and Middleware

Confirm that `Bookstore.Web` has been updated to use the modern ASP.NET Core hosting model if it was previously using the legacy `System.Web`-based pipeline. Specifically:

- `Startup.cs` or the top-level `Program.cs` should use `WebApplication.CreateBuilder`.
- Any `HttpModule` or `HttpHandler` implementations from `System.Web` must be replaced with ASP.NET Core middleware.
- `web.config` should only contain IIS-specific settings if IIS hosting is required; application configuration should reside in `appsettings.json`.

---

## 9. Verify Logging and Error Handling

Ensure that logging is configured using `Microsoft.Extensions.Logging` and that any legacy logging frameworks (e.g., `log4net`, `NLog`) have been updated to versions compatible with cross-platform .NET, or replaced with a supported alternative.