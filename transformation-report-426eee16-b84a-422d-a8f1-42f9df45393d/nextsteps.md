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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it references the appropriate ASP.NET Core meta-package or individual packages rather than legacy `System.Web` dependencies.

---

## 4. Check Runtime Configuration Files

Verify that the following files exist and are correctly configured in `Bookstore.Web`:

- `appsettings.json` — should contain connection strings and application settings previously found in `Web.config` or `App.config`.
- `appsettings.Development.json` — should contain environment-specific overrides.
- `Program.cs` — should contain the application entry point and service registration.

If connection strings were previously stored in `Web.config`, ensure they have been moved to `appsettings.json` under the `ConnectionStrings` section:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

---

## 5. Validate the Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- The `DbContext` class is correctly configured.
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify that core functionality works as expected, including:

- Page rendering
- Database reads and writes
- Authentication and authorization, if applicable

---

## 7. Run Automated Tests

If the solution contains test projects, execute them to confirm existing behavior is preserved:

```bash
dotnet test
```

Review any failing tests and determine whether they reflect genuine regressions or tests that require updates due to API changes in the new framework version.

---

## 8. Review Removed or Changed APIs

Cross-reference the codebase against the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [.NET API compatibility documentation](https://learn.microsoft.com/en-us/dotnet/core/compatibility/) to identify any runtime behaviors that may differ from the original .NET Framework implementation, even when no build errors are present. Common areas to check include:

- `HttpContext` usage
- Session and cookie handling
- Global error handling middleware
- Static file serving configuration