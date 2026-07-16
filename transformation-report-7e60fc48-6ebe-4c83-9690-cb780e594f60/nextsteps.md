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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project references `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity`. Run any existing database migrations to verify compatibility.
- **`Bookstore.Web`**: If this was previously an ASP.NET Web Forms or ASP.NET MVC (.NET Framework) project, confirm it has been migrated to ASP.NET Core. Check `Program.cs` and `Startup.cs` (or the combined `Program.cs` in .NET 6+) for correct middleware configuration.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or configuration-related code functions as expected under the new runtime.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are caused by behavioral differences in the new runtime or by pre-existing issues.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, apply and verify migrations against a development database.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the schema is created correctly and that basic CRUD operations function as expected.

---

## 7. Run the Application Locally

Start the web application locally and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and test the following at a minimum:

- Application startup with no runtime exceptions
- Page rendering and routing
- Database read and write operations
- Any authentication or authorization flows

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Key areas to check include:

- Connection strings
- Logging configuration
- Application-specific settings

Legacy `<appSettings>` and `<connectionStrings>` sections from `Web.config` must be represented in `appsettings.json` using the ASP.NET Core configuration format.

---

## 9. Address Runtime Warnings

After running the application, review the console and log output for any runtime warnings. Common post-migration warnings include:

- Obsolete API usage
- Missing middleware registrations
- Deprecated configuration patterns

Address each warning to ensure long-term maintainability of the codebase.