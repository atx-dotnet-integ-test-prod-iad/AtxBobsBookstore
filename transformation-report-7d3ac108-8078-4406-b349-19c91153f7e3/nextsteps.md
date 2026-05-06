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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or `netstandard2.0`, update it accordingly and re-run the build.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the code in all three projects for any APIs that are Windows-only. Common areas to check include:

- `System.Web` references (not available on .NET Core/5+)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions (e.g., backslashes)
- `HttpContext` usage that may have changed between ASP.NET and ASP.NET Core

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific calls.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the version being used is Entity Framework Core and not the legacy `EntityFramework` (6.x) package.

```bash
dotnet ef dbcontext info --project app/Bookstore.Data
```

- Verify that migrations exist and are up to date.
- If no migrations exist, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project app/Bookstore.Data
dotnet ef database update --project app/Bookstore.Data
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, run all tests to verify that business logic and data access behavior is preserved after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, particularly around:

- Serialization (`System.Text.Json` vs `Newtonsoft.Json`)
- Globalization and culture handling
- Middleware and HTTP pipeline behavior in ASP.NET Core

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

- Navigate through the application in a browser.
- Test all major user-facing features such as browsing, searching, and any checkout or account functionality.
- Check the console output and application logs for runtime exceptions or deprecation warnings.

---

## 8. Review `appsettings.json` Configuration

ASP.NET Core uses `appsettings.json` instead of `Web.config`. Confirm that:

- Database connection strings have been moved to `appsettings.json`.
- Any application settings previously in `<appSettings>` in `Web.config` have been migrated.
- Environment-specific overrides exist in `appsettings.Development.json` and `appsettings.Production.json` as needed.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web -c Release -o ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web -c Release -r linux-x64 --self-contained true -o ./publish
```

Verify the contents of the `./publish` directory and confirm the application starts correctly from the published output before deploying to the target environment.