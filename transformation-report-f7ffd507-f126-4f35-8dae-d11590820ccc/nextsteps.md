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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, locate them in the respective `.csproj` files and replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Compatibility

### Check for Windows-Specific APIs
Even if the project builds successfully, certain APIs may have been used that are only supported on Windows. Run the .NET Compatibility Analyzer if it is not already referenced:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any `CA1416` platform compatibility warnings that appear.

### Review `Bookstore.Data`
If this project uses Entity Framework, confirm the correct version is referenced:
- For EF Core, ensure the provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) matches the target .NET version.
- Run any pending migrations or verify the database schema is still compatible:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Run Unit Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test project currently exists, consider creating one targeting the `Bookstore.Domain` and `Bookstore.Data` projects to validate core business logic and data access behavior.

---

## 5. Run the Application Locally

Start the `Bookstore.Web` project and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without runtime exceptions.
- All routes and pages load correctly.
- Database connectivity is functioning (check connection strings in `appsettings.json`, as these may have been previously stored in `Web.config`).
- Any authentication or session handling works as expected under ASP.NET Core middleware.

---

## 6. Review Configuration Migration

Legacy .NET Framework projects use `Web.config` for configuration. ASP.NET Core uses `appsettings.json`. Verify the following have been moved correctly:

- Connection strings are present in `appsettings.json` or environment variables.
- Any `appSettings` keys have been transferred.
- `system.web` or `system.webServer` configuration entries have been replaced with the appropriate ASP.NET Core middleware in `Program.cs` or `Startup.cs`.

---

## 7. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for a web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Avoid `net8.0-windows` unless Windows-specific APIs are genuinely required, as it limits cross-platform portability.