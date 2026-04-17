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

Review the output for any warnings about deprecated or unlisted packages that may need to be updated to versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility, as these can indicate areas that may cause runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Even when a build succeeds, some packages or APIs used in the original project may only function on Windows. Use the .NET Compatibility Analyzer or review the following:

- Any use of `Microsoft.Win32` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- COM interop or P/Invoke calls

Run the following to check for platform compatibility warnings:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, and any data access features, to confirm end-to-end functionality.

---

## 6. Verify Database Connectivity

If the `Bookstore.Data` project uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is valid for the target environment.
- Any pending migrations are applied.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project was migrated from Entity Framework 6, confirm that the migration to EF Core was completed and that all `DbContext` configurations are correct.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are caused by the migration or pre-existing issues.

---

## 8. Test on a Non-Windows Platform

Since the goal of the transformation is cross-platform compatibility, validate the application on a Linux or macOS environment if possible.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Pay attention to:

- File path separator differences
- Case-sensitive file system behavior on Linux
- Any environment-specific configuration values

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.