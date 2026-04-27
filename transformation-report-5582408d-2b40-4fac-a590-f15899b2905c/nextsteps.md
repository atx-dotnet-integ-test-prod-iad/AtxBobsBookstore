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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Even when a project builds successfully, it may still contain APIs or packages that only function on Windows. Run the compatibility analyzer to surface any such issues.

```bash
dotnet build /p:EnableNETAnalyzers=true /p:PlatformCompatibilityAnalyzer=true
```

Pay particular attention to:
- `System.Web` references (not supported on cross-platform .NET)
- Windows Registry access
- COM interop
- `HttpContext` usage patterns that differ from ASP.NET Core

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test project exists, consider writing basic integration or unit tests for the core domain and data layers before proceeding.

---

## 6. Validate the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the data layer specifically:

- Confirm Entity Framework Core (not EF6) is being used if the project relies on Entity Framework.
- Check that the `DbContext` configuration uses the new `OnConfiguring` or `AddDbContext` patterns appropriate for EF Core.
- Run any pending migrations or verify the schema against the target database.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- Application starts without runtime exceptions
- Database connectivity is functional
- Key pages and routes load correctly
- Authentication and authorization behave as expected, if applicable

---

## 8. Review Configuration Files

Ensure that `Web.config` settings have been properly migrated to `appsettings.json` and that environment-specific configuration is handled via `appsettings.{Environment}.json`.

Verify that connection strings, logging settings, and any custom application settings are present and correctly structured.

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

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.