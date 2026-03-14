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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects. A mismatch in target frameworks between `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` can cause runtime issues even when the build succeeds.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for APIs or packages that are Windows-only, such as:

- `Microsoft.Win32` registry access
- `System.Drawing` (requires `System.Drawing.Common` and has platform limitations)
- Windows Communication Foundation (WCF) client/server code
- Any P/Invoke calls targeting Windows DLLs

If any are found, replace them with cross-platform alternatives or add a runtime platform check.

---

## 5. Validate Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core provider package is installed (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Migrations are present and up to date.
- Run the following to apply migrations against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Verify that connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to verify functional correctness after migration.

```bash
dotnet test
```

Review any failing tests carefully. Failures after migration often indicate:

- Behavioral differences in .NET APIs compared to .NET Framework
- Missing configuration or dependency injection setup
- Changed default serialization behavior (e.g., `System.Text.Json` vs `Newtonsoft.Json`)

---

## 7. Run the Application Locally

Start the `Bookstore.Web` project locally and verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually test the following areas:

- Application startup and routing
- Database read and write operations
- Any authentication or authorization flows
- Static file serving

---

## 8. Review Configuration and Secrets

Confirm that `appsettings.json` and `appsettings.{Environment}.json` files contain the correct values for the target environment. Sensitive values such as connection strings and API keys should be managed using the .NET Secret Manager for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target server.