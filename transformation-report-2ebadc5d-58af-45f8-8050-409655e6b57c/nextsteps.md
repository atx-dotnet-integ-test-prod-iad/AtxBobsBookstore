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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues introduced during migration.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

- Verify that all previously passing tests continue to pass.
- If tests were written against .NET Framework-specific behavior (e.g., `System.Web`, `HttpContext`), review and update them to use the ASP.NET Core equivalents.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) is targeting the correct cross-platform provider. For example, if SQL Server is used, ensure the `Microsoft.EntityFrameworkCore.SqlServer` package is referenced rather than any legacy `EntityFramework` package.
- Run any pending migrations or verify that the database schema is consistent:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist, consider generating an initial migration to establish a baseline.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models for any types that relied on .NET Framework-only assemblies (e.g., `System.Drawing`, `System.Web`).
- Confirm that serialization attributes or data annotations are sourced from `System.ComponentModel.DataAnnotations`, which is available cross-platform.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Start the application locally and navigate through its primary workflows:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Check the following areas specifically, as they are common sources of runtime issues after migration from ASP.NET to ASP.NET Core:
  - Authentication and authorization configuration in `Program.cs` or `Startup.cs`.
  - Static file serving (previously handled by IIS; now requires `app.UseStaticFiles()`).
  - Session and cookie configuration.
  - Any use of `HttpContext.Current`, which does not exist in ASP.NET Core and must be replaced with injected `IHttpContextAccessor`.
  - Configuration values previously read from `Web.config` should now be sourced from `appsettings.json` via `IConfiguration`.

---

## 7. Review `appsettings.json`

Ensure that all connection strings and application settings previously defined in `Web.config` or `App.config` have been correctly transferred to `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

---

## 8. Test on Target Runtime

If the application is intended to run on Linux or macOS as part of the cross-platform goal, run the application on the target operating system and verify:

- File path separators are handled correctly (use `Path.Combine` rather than hardcoded backslashes).
- File system operations are case-sensitive on Linux; verify that all file references use consistent casing.
- Any Windows-specific APIs (e.g., registry access, Windows Authentication) are either replaced or conditionally compiled.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory before deploying to confirm all required assets are present.