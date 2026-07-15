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

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, some APIs or packages may only function correctly on Windows. Review the following areas:

- Any use of `Microsoft.Win32` or `System.Windows` namespaces.
- Registry access or Windows-specific file paths.
- Any remaining references to `System.Web`, which is not available in cross-platform .NET.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific code paths.

---

## 5. Validate the Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- If Entity Framework is in use, confirm it has been migrated to **Entity Framework Core**.
- Run any existing database migrations to ensure the schema is compatible.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If raw ADO.NET is used, confirm that the connection strings and providers are compatible with the target database on the new runtime.

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic smoke tests for the core domain logic in `Bookstore.Domain` and the data access methods in `Bookstore.Data` before deploying.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All pages and routes load as expected.
- Database connectivity is functional.
- Any authentication or session handling works correctly.

Review the application logs for runtime warnings or errors that would not have appeared at build time.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) are properly configured. Legacy `Web.config` or `App.config` values should have been migrated to `appsettings.json`. Confirm:

- Connection strings are present and correct.
- Any application settings previously in `<appSettings>` have been moved.
- Environment-specific configuration is handled using the `IConfiguration` system.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present.