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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit each project for APIs or packages that are Windows-only. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Communication Foundation (WCF)**
- **System.Drawing** (use `System.Drawing.Common` with caution, or migrate to a cross-platform alternative)
- **Web.config** transformations (these should be replaced with `appsettings.json`)

Use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify remaining platform-specific calls.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target framework version.
- If Entity Framework 6 was used in the original project, verify whether it has been migrated to **Entity Framework Core**, as EF6 has limited cross-platform support.
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Validate the Domain Layer (`Bookstore.Domain`)

- Confirm that all domain models, interfaces, and business logic compile without warnings.
- Check that no domain classes have dependencies on infrastructure or web-specific libraries, which would violate separation of concerns.

---

## 7. Validate the Web Layer (`Bookstore.Web`)

- If this was previously an ASP.NET Web Forms or ASP.NET MVC (.NET Framework) project, confirm it has been migrated to **ASP.NET Core**.
- Verify that `Program.cs` and `appsettings.json` are present and correctly configured.
- Check that middleware, dependency injection registrations, and routing are set up in `Program.cs` (or `Startup.cs` if applicable).
- Confirm that any authentication/authorization configuration has been updated to use ASP.NET Core Identity or the appropriate middleware.

---

## 8. Run the Application Locally

Start the web application and verify basic functionality:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser.
- Test core user flows such as browsing books, authentication (if applicable), and any data-driven pages.
- Review the console output and application logs for runtime exceptions.

---

## 9. Run Existing Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test
```

Review failing tests to determine whether failures are due to migration issues or pre-existing problems. Pay particular attention to tests that mock or interact with the data layer, as EF Core behavior can differ from EF6.

---

## 10. Cross-Platform Smoke Test

If cross-platform support is a requirement, run the application on a non-Windows OS (Linux or macOS) to surface any remaining platform-specific issues:

```bash
dotnet run --project Bookstore.Web
```

Address any `PlatformNotSupportedException` or similar runtime errors that appear only on non-Windows platforms.