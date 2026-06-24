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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or `netstandard2.0`, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, inspect each project for any remaining Windows-only dependencies such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- COM interop references

These will not function on Linux or macOS. Replace or remove them as appropriate for cross-platform compatibility.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the URL printed in the console output (typically `http://localhost:5000` or `https://localhost:5001`) and verify the application loads and behaves correctly.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is correct for your environment.
- Any pending migrations are applied.

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the project was migrated from Entity Framework 6, confirm that EF Core equivalents are in place for any EF6-specific features such as lazy loading proxies or complex type mappings.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to confirm existing functionality is preserved.

```bash
dotnet test
```

Review any failing tests and determine whether they reflect genuine regressions or tests that need to be updated to reflect the new project structure.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains all settings that were previously held in `Web.config` or `App.config`. Common items to check include:

- Connection strings
- Application-specific settings
- Logging configuration

The `Web.config` file is not used in cross-platform .NET and should not be relied upon at runtime.

---

## 9. Publish the Application

Once the application has been validated locally, publish it to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web -c Release -o ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web -c Release -r linux-x64 --self-contained true -o ./publish
```

Verify the contents of the `./publish` folder before deploying to the target environment.