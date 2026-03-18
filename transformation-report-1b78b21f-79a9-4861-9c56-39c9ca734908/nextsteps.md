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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Use the .NET Compatibility Analyzer or review package references manually to identify any libraries that only function on Windows. Common areas to check include:

- Registry access (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) client usage
- `System.Drawing` (requires additional setup on Linux/macOS)
- Any P/Invoke calls targeting Windows-only system DLLs

If any are found, replace them with cross-platform alternatives or conditionally compile them using runtime checks.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing behavior is preserved after migration:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any test failures carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new .NET runtime.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- The connection string in `appsettings.json` (or equivalent) is correct for the target environment.
- Entity Framework Core migrations (if applicable) are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used Entity Framework 6 (EF6), confirm it has been migrated to Entity Framework Core, as EF6 has limited cross-platform support.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm functionality is intact. Pay attention to:

- Routing and middleware configuration
- Authentication and authorization behavior
- Static file serving
- Any features that relied on `System.Web` or `HttpContext` from the legacy ASP.NET stack

---

## 8. Cross-Platform Smoke Test

If the goal is to run on Linux or macOS, execute the above steps on the target operating system to confirm there are no runtime issues that did not surface during the Windows build.

---

## 9. Review Configuration and Environment Variables

Confirm that configuration sources have been updated appropriately. Legacy `web.config` or `app.config` files should be replaced or supplemented by:

- `appsettings.json`
- `appsettings.{Environment}.json`
- Environment variables

Verify that all required configuration keys are present and that the application reads them correctly at startup.