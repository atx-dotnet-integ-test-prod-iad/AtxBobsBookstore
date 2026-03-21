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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to their latest stable versions compatible with your target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was captured in the initial error report.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid interoperability issues.

---

## 4. Check for Windows-Specific Dependencies

Even when a project builds successfully, it may still contain APIs or packages that only function on Windows. Run the .NET compatibility analyzer or review the following areas manually:

- Any use of `Microsoft.Win32` or `System.Windows` namespaces
- Registry access (`RegistryKey`)
- Windows-specific file path assumptions (e.g., backslashes, drive letters)
- `System.Drawing` (requires additional setup on Linux/macOS)

---

## 5. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm the following in that project:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`)
- Any database migrations are present and up to date

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data
dotnet ef database update --project app/Bookstore.Data
```

---

## 6. Run Unit Tests

If a test project exists in the solution, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting `Bookstore.Domain` at a minimum, as it is the most independent layer of the solution.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Check the following after startup:

- The application loads without exceptions in the console output
- Key pages or endpoints return expected responses
- Database connectivity is functioning (check logs for connection errors)
- Static assets (CSS, JS) are served correctly

---

## 8. Review Configuration Files

Inspect `appsettings.json` and `appsettings.Production.json` in `Bookstore.Web` for the following:

- Connection strings are correct for the target environment
- Any legacy `Web.config` or `App.config` values have been migrated to `appsettings.json`
- Logging configuration is appropriate

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web -c Release -o ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web -c Release -r linux-x64 --self-contained true -o ./publish
```

Verify the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.