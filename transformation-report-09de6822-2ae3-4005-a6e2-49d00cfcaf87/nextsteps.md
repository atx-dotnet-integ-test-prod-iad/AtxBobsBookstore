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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

- `Bookstore.Domain.csproj`
- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining platform-specific code.

---

## 5. Run the Data Layer Migrations

If `Bookstore.Data` uses Entity Framework, verify that any existing migrations are compatible with the new runtime. Run the following to check the current migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate functional correctness:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests to determine whether failures are due to migration issues or pre-existing defects. Pay particular attention to tests covering:

- Data access logic in `Bookstore.Data`
- Domain model behavior in `Bookstore.Domain`
- HTTP request handling and routing in `Bookstore.Web`

---

## 7. Run the Application Locally

Start the web application and verify it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following:

- Application starts without exceptions
- Database connectivity is functional
- Core user-facing pages load and behave as expected
- Authentication and authorization flows work correctly, if applicable

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) contain all necessary configuration values that were previously held in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Application settings
- Logging configuration
- Authentication settings

---

## 9. Validate Publish Output

Perform a publish to confirm the output is complete and self-contained:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, static assets, and dependencies are present.