# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

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

If any project is still targeting `net472` or another legacy framework, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific APIs

Since this was a legacy project, verify that no Windows-only APIs (such as the Windows Registry, `System.Web`, or WCF server-side components) remain in use. Tools that can assist with this include:

- **[.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview)** — can flag platform-specific API usage.
- **[Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer)** — surfaces warnings at build time for platform-specific calls.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review test results carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, such as changes in globalization, JSON serialization defaults, or HTTP client behavior.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to validate include:

- **Data access** — Confirm that `Bookstore.Data` connects to the database correctly. Check the connection string configuration in `appsettings.json`, as the legacy `Web.config` connection strings will not be used in modern .NET.
- **Routing and middleware** — Verify that all routes resolve as expected.
- **Authentication and authorization** — If the application uses ASP.NET Identity or cookie-based auth, confirm that the middleware is configured correctly in `Program.cs` or `Startup.cs`.
- **Static files** — Ensure CSS, JavaScript, and image assets are served correctly.

---

## 7. Review Configuration Migration

Legacy .NET Framework applications use `Web.config` and `App.config`. Modern .NET uses `appsettings.json`. Confirm that all necessary configuration values (connection strings, app settings, etc.) have been moved to `appsettings.json` and are being read via `IConfiguration`.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.