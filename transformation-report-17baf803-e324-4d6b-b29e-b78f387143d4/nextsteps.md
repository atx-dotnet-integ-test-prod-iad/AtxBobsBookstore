# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was reported:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and intended version of .NET (e.g., `net8.0`):

- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that existed in .NET Framework but have changed or been removed in modern .NET. Common areas to check include:

- `System.Web` references (not available in modern .NET; should be replaced with ASP.NET Core equivalents)
- `HttpContext`, `HttpRequest`, and `HttpResponse` usage
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `System.Runtime.Remoting` or `System.Security.Permissions`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if you need further assistance identifying incompatible API usage.

---

## 5. Review `Bookstore.Data` for Entity Framework Changes

If `Bookstore.Data` uses Entity Framework, confirm whether it has been migrated from EF6 to EF Core, as EF Core has behavioral and API differences. Key areas to verify:

- Database context configuration (`OnConfiguring`, `OnModelCreating`)
- Connection string setup (now typically done via `appsettings.json` and dependency injection)
- Any raw SQL queries or stored procedure calls
- Lazy loading behavior (disabled by default in EF Core)

Run any existing EF migrations to confirm the schema is intact:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Review `Bookstore.Web` Configuration

Modern .NET web applications use `appsettings.json` and the `Program.cs` / `Startup.cs` pattern instead of `Web.config`. Verify the following:

- Connection strings are present in `appsettings.json`
- Any previously used `Web.config` settings (e.g., custom error pages, HTTP handlers, modules) have been replaced with ASP.NET Core middleware equivalents
- Authentication and authorization configuration has been updated to use ASP.NET Core Identity or middleware if applicable

---

## 7. Run Unit Tests

If the solution contains test projects, run them to validate that core logic remains intact after migration:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 8. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web
```

Navigate through the application and verify that core functionality such as browsing, data retrieval, and any forms or user interactions work as expected.

---

## 9. Review Logging and Error Handling

Ensure that logging has been configured using `Microsoft.Extensions.Logging` and that any legacy logging frameworks (e.g., `log4net`, `NLog`) are either updated to their .NET-compatible versions or replaced. Check that unhandled exceptions are surfaced appropriately during local testing.

---

## 10. Prepare for Deployment

Once local validation is complete:

1. Publish the application using:
   ```bash
   dotnet publish --configuration Release --output ./publish
   ```
2. Confirm the output directory contains all necessary files including `appsettings.json`.
3. Ensure the target server or hosting environment has the correct .NET runtime installed. You can verify the required runtime version from the `<TargetFramework>` in `Bookstore.Web.csproj`.
4. Update any environment-specific configuration (e.g., production connection strings) before deploying.