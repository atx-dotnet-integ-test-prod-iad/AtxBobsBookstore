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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Runtime Dependencies

Some libraries that compiled without errors under .NET Framework may behave differently at runtime under cross-platform .NET. Pay particular attention to:

- **Entity Framework**: Confirm the correct EF Core version is referenced in `Bookstore.Data` and that migrations are compatible.
- **Configuration**: Verify that `appsettings.json` is present and correctly structured in `Bookstore.Web`, replacing any legacy `Web.config` or `App.config` entries.
- **Authentication/Authorization**: If any Windows-specific authentication mechanisms were used, confirm they have been replaced or configured appropriately for cross-platform use.

---

## 4. Run Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and apply them against your target database.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute all tests to verify that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected.

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and cross-platform .NET rather than simple compilation issues.

---

## 6. Run the Application Locally

Start the web application locally and verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas manually:

- Application startup completes without exceptions.
- Database connectivity is established.
- Core user-facing features (browsing, searching, and purchasing books) function as expected.
- Logging output does not contain unhandled exceptions or critical warnings.

---

## 7. Check for Platform-Specific Code

Search the solution for any remaining platform-specific APIs that may cause issues on non-Windows environments.

Areas to inspect:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Registry access via `Microsoft.Win32`.
- Windows-specific file path assumptions (e.g., backslashes).
- COM interop or P/Invoke calls targeting Windows-only libraries.

Use `dotnet` compatibility analyzers or the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) to identify any remaining compatibility issues.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to your target environment.