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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

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

Ensure none of the projects still reference `net48` or any other .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any APIs or packages that are Windows-only. Common areas to check include:

- `System.Web` references (should have been replaced with `Microsoft.AspNetCore.*`)
- Registry access (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side components
- Any P/Invoke calls targeting Windows-specific native libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining platform-specific code.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- Confirm the project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- If migrations exist, run them against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used Entity Framework 6 (EF6), ensure the migration to EF Core is complete and that all queries, relationships, and configurations behave as expected.

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests:

```bash
dotnet test
```

If no test project currently exists, consider adding one targeting critical areas such as:

- Domain model logic in `Bookstore.Domain`
- Repository or data access methods in `Bookstore.Data`
- Controller actions and middleware in `Bookstore.Web`

---

## 7. Run the Application Locally

Start the web application and verify it runs correctly on the local development machine:

```bash
dotnet run --project Bookstore.Web
```

Confirm the following manually:

- The application starts without runtime exceptions
- Key pages and routes load correctly
- Database reads and writes function as expected
- Authentication and authorization behave correctly if applicable
- Static assets (CSS, JavaScript, images) are served properly

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) contain all necessary configuration values that were previously stored in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Application settings keys
- Logging configuration
- Authentication settings

The `Web.config` and `App.config` files are not used by .NET applications in the same way. Confirm all relevant values have been migrated to the `appsettings.json` structure.

---

## 9. Validate Middleware and HTTP Pipeline

In `Bookstore.Web`, review `Program.cs` (or `Startup.cs` if still present) to confirm the middleware pipeline is configured correctly. Ensure the following are in place as needed:

- `app.UseRouting()`
- `app.UseAuthentication()` and `app.UseAuthorization()`
- `app.UseStaticFiles()`
- `app.MapControllers()` or `app.MapRazorPages()` depending on the project type

---

## 10. Deploy to Target Environment

Once local validation is complete, publish the application for deployment:

```bash
dotnet publish --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the target environment has the correct .NET runtime installed:

```bash
dotnet --list-runtimes
```

If deploying to IIS, install the [.NET Hosting Bundle](https://dotnet.microsoft.com/en-us/download/dotnet) on the server and configure the application pool to use **No Managed Code**, as the ASP.NET Core module handles process management directly.