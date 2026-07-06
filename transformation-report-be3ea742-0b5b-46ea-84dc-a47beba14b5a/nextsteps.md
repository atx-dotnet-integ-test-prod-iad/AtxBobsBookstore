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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether the failures are caused by migration-related changes, such as behavioral differences in APIs between .NET Framework and modern .NET.

---

## 5. Validate the Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- **Entity Framework Core**: If the project uses Entity Framework, confirm it has been migrated from EF 6 to EF Core and that the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- **Connection Strings**: Check that connection strings in `appsettings.json` are correctly configured and that `System.Configuration.ConfigurationManager` references have been replaced with `Microsoft.Extensions.Configuration`.
- **Migrations**: If using EF Core migrations, run the following to verify the database schema is up to date:

```bash
dotnet ef migrations list
dotnet ef database update
```

---

## 6. Validate the Web Layer

For `Bookstore.Web`, confirm the following:

- **Startup Configuration**: Ensure `Startup.cs` or the top-level `Program.cs` correctly registers services and middleware using the modern .NET hosting model.
- **Static Files and Views**: Run the application locally and navigate through the UI to confirm that views render correctly and static assets are served as expected.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or cookie-based auth, verify that the middleware is configured correctly in the request pipeline.

Start the application locally with:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Check for Windows-Specific APIs

Even without build errors, some APIs may compile successfully but fail at runtime on non-Windows platforms. Search the codebase for usage of the following and assess whether replacements are needed:

- `System.Web` namespaces
- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., backslashes)
- COM interop or P/Invoke calls

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this review.

---

## 8. Test on Target Platform

If the goal is cross-platform deployment (e.g., Linux), run the application on the target operating system to catch any runtime issues that would not appear on Windows.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then execute the published output on the target machine and verify expected behavior.

---

## 9. Review Deprecated or Removed APIs

Check the [.NET breaking changes documentation](https://learn.microsoft.com/en-us/dotnet/core/compatibility/) for any APIs that were removed or changed between .NET Framework and the target .NET version. Pay particular attention to:

- `HttpContext` and `HttpRequest` differences in ASP.NET Core
- Changes to serialization behavior (`System.Text.Json` vs `Newtonsoft.Json`)
- Thread and task scheduling differences