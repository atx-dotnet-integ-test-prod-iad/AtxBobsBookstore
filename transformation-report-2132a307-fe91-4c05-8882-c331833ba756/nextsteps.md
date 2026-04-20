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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

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

Ensure the build completes with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid `netstandard` targets unless the project is intended to be a shared library consumed by multiple frameworks.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to:

- **`Bookstore.Data`**: If Entity Framework is used, confirm it has been migrated from EF6 to EF Core. EF Core has different behaviors around lazy loading, migrations, and configuration.
- **`Bookstore.Web`**: If this was an ASP.NET MVC or Web Forms project, confirm it has been converted to ASP.NET Core MVC. Web Forms is **not supported** on cross-platform .NET.
- **`System.Web` references**: These are not available in .NET Core or later. Any remaining usage must be replaced with ASP.NET Core equivalents.

Search the codebase for any remaining references to `System.Web`:

```bash
grep -r "System.Web" --include="*.cs"
```

---

## 5. Run Database Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and test the core functionality, including:

- Page rendering
- Database read and write operations
- Authentication and authorization flows, if present
- Any file upload or download features

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to confirm expected behavior is preserved:

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to behavioral differences in the new framework or pre-existing issues.

---

## 8. Review Configuration Files

In modern .NET, configuration has moved from `Web.config` to `appsettings.json`. Confirm the following:

- Connection strings are present in `appsettings.json` or environment variables.
- Any `Web.config` or `App.config` entries that were relied upon at runtime have been migrated.
- Secrets are not stored in source-controlled files. Use the `dotnet user-secrets` tool for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 9. Validate Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to confirm:

- Middleware is registered in the correct order.
- Services such as database contexts, authentication, and logging are properly registered in the dependency injection container.
- Static files, routing, and error handling are configured correctly.

---

## 10. Test on Target Operating Systems

Since the goal is cross-platform compatibility, test the application on each intended operating system (Windows, Linux, macOS) to identify any platform-specific issues such as:

- File path separators (`\` vs `/`)
- Case-sensitive file system behavior on Linux
- Platform-specific NuGet packages or native dependencies