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

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any dependencies that are Windows-only, such as:

- `System.Web`
- `Microsoft.Web.Infrastructure`
- Windows Registry access
- COM interop

Replace or remove any such dependencies with cross-platform equivalents where applicable.

---

## 5. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework, confirm the correct EF Core provider is referenced and that any migrations are up to date.

```bash
dotnet ef migrations list --project Bookstore.Data
```

If migrations are missing or outdated, create a new migration and apply it to the target database.

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data
dotnet ef database update --project Bookstore.Data
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate core functionality.

```bash
dotnet test --configuration Release
```

Review any failing tests and address issues related to API changes between .NET Framework and .NET.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally and verify that the application runs as expected.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify key workflows such as browsing, searching, and any data submission forms.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

The legacy `<connectionStrings>` and `<appSettings>` sections from `Web.config` should now reside in `appsettings.json` using the appropriate JSON structure.

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

## 9. Validate Middleware and HTTP Pipeline

In `Bookstore.Web`, review `Program.cs` or `Startup.cs` to confirm that the ASP.NET Core middleware pipeline is configured correctly, including:

- Authentication and authorization middleware
- Static file serving
- Routing
- Error handling

---

## 10. Publish the Application

Once all validation steps pass, publish the application to a target directory.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.