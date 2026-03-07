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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure that `Bookstore.Data` and `Bookstore.Domain` are not still referencing `net48` or any other legacy framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the following areas for any remaining Windows-specific dependencies:

- **`Bookstore.Data`**: Check for any usage of `System.Data.SqlClient`. If present, replace it with `Microsoft.Data.SqlClient`, which has cross-platform support.
- **`Bookstore.Web`**: Confirm that no `System.Web` references remain. These are not supported on cross-platform .NET.
- Review any use of Windows registry access, Windows-specific file paths, or COM interop.

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL provided in the console output and verify that the application loads and core functionality works as expected, including:

- Browsing or searching for books
- Any data retrieval from `Bookstore.Data`
- Domain logic executed through `Bookstore.Domain`

---

## 6. Run Existing Tests

If the solution contains a test project, execute the tests to validate that behavior has not regressed:

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to tests that exercise data access or domain logic, as these layers are most likely to be affected by a framework migration.

---

## 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Connection strings in `appsettings.json` are correct and accessible from the new runtime environment.
- Run any pending migrations if applicable:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) to confirm:

- Middleware is registered using the current .NET minimal hosting model or the updated `Startup` pattern.
- Configuration sources such as `appsettings.json` and environment variables are loading correctly.
- Any legacy `HttpModule` or `HttpHandler` patterns have been replaced with the appropriate ASP.NET Core middleware equivalents.

---

## 9. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, consider running the application on Linux or macOS to confirm there are no hidden platform-specific issues:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

This can be done on a Linux machine or within a Linux-based environment to surface any remaining platform dependencies.