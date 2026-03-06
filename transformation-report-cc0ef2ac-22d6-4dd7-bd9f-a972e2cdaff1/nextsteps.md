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

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still actively supported.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit the code for any APIs or libraries that are Windows-only. Common areas to check include:

- `System.Web` references (not available in .NET Core and later)
- Windows Registry access (`Microsoft.Win32.Registry`)
- COM interop or P/Invoke calls targeting Windows DLLs
- Any use of `HttpContext` from `System.Web` rather than `Microsoft.AspNetCore.Http`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to help identify these.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify runtime behavior has not changed:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 6. Validate the Web Application Locally

Start the web application and verify it runs correctly on your local machine:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- Application starts without exceptions
- Database connectivity works as expected (check connection strings in `appsettings.json`)
- Key pages and routes load correctly
- Any authentication or authorization flows behave as expected

---

## 7. Review Configuration Files

Ensure that configuration has been correctly migrated from `Web.config` or `App.config` to the `appsettings.json` format used by modern .NET. Pay attention to:

- Connection strings
- Application settings keys
- Environment-specific configuration (`appsettings.Development.json`, `appsettings.Production.json`)

---

## 8. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct version is in use:

- **Entity Framework Core** is the supported version for cross-platform .NET.
- **Entity Framework 6** has limited .NET support and should be migrated to EF Core where possible.

If using EF Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to your target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Test on a Non-Windows Platform (If Required)

If cross-platform support is a goal, run the application on Linux or macOS to confirm there are no platform-specific runtime failures:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Address any `PlatformNotSupportedException` or similar runtime errors that appear only on non-Windows systems.