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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If an older or end-of-life version such as `net6.0` is present, consider updating to a long-term support (LTS) release.

---

## 4. Verify Configuration Files

Check that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are present and correctly configured. Legacy `Web.config` or `App.config` settings should have been migrated to `appsettings.json`.

Confirm that connection strings, logging configuration, and any application-specific settings are accurate.

---

## 5. Run Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and can be applied to the target database.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations if necessary:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, managing inventory, and any authentication flows, to confirm expected behavior.

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to validate that business logic and data access behave correctly after migration.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration issues or pre-existing defects.

---

## 8. Check for Removed or Changed APIs

Some .NET Framework APIs are not available in cross-platform .NET. Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` compatibility tools to identify any runtime-level API usage that may not have surfaced as build errors but could cause issues at runtime.

Pay particular attention to:

- `System.Web` references (should be replaced with ASP.NET Core equivalents)
- Windows-only APIs (e.g., registry access, certain cryptography providers)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

---

## 9. Validate on Target Operating System

If the intent of the migration is cross-platform support, run the application on the target operating system (Linux or macOS) to surface any platform-specific issues that would not appear on Windows.

```bash
dotnet run --project Bookstore.Web
```

---

## 10. Review Logging and Error Handling

Confirm that the logging configuration in `Bookstore.Web` is functioning correctly and that unhandled exceptions are captured appropriately. ASP.NET Core uses `Microsoft.Extensions.Logging` by default, which differs from legacy logging approaches.