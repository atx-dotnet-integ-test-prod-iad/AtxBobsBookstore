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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure consistency across all three projects so there are no version mismatches between `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web`.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, some APIs or packages may only function correctly on Windows. Run the .NET compatibility analyzer or review the project for usage of:

- `Microsoft.Win32` namespaces
- Windows Registry access
- COM interop
- `System.Web` (which is not available in cross-platform .NET)

If `System.Web` references exist anywhere, they must be replaced with their ASP.NET Core equivalents.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate runtime behavior:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or smoke tests that cover:

- Database connectivity via `Bookstore.Data`
- Core domain logic in `Bookstore.Domain`
- Key HTTP endpoints in `Bookstore.Web`

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`)
- Connection strings in `appsettings.json` are correct and accessible
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm end-to-end functionality is intact.

---

## 8. Review Application Logs

After running the application, review the console output and any log files for runtime exceptions or deprecation warnings that would not have surfaced during compilation.

---

## 9. Test on Target Platform

If the goal is cross-platform deployment (e.g., Linux), run the application on the target operating system to catch any platform-specific runtime issues that may not appear on Windows:

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then execute the published output on the target machine and verify behavior matches the local run.