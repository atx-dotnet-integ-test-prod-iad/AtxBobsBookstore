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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what the error report captured:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the `Bookstore.Data` and `Bookstore.Web` projects for any remaining Windows-specific APIs or packages, such as:

- `Microsoft.Win32` namespaces
- Windows Registry access
- COM interop references
- Any NuGet packages that only support `net4x` or `windows` target frameworks

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package if platform-specific code paths are needed.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify runtime behavior has not changed:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm the connection string in `appsettings.json` is correct for the target environment.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm functional correctness.

---

## 8. Review Middleware and Configuration (Bookstore.Web)

Confirm that the `Bookstore.Web` project has been updated to use the modern ASP.NET Core hosting model. Specifically:

- `Program.cs` should use the minimal hosting API (no separate `Startup.cs` unless intentionally retained).
- `appsettings.json` and `appsettings.{Environment}.json` are present and correctly structured.
- Authentication, authorization, and any custom middleware have been re-registered using the current ASP.NET Core conventions.

---

## 9. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform support, validate the application runs correctly on Linux or macOS if those are target deployment environments:

```bash
dotnet run --project Bookstore.Web
```

This will surface any remaining platform-specific issues that may not appear on Windows.