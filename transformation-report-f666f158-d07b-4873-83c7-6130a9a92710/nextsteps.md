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

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Even when a build succeeds, some NuGet packages or APIs may only function on Windows. Review the dependencies in each `.csproj` for packages that are known to be Windows-only, such as those relying on `System.Web`, COM interop, or the Windows Registry.

Use the .NET Upgrade Assistant compatibility analyzer or the following command to check for platform-specific API usage:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Address any `CA1416` platform compatibility warnings that appear.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain correct after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review test output carefully for any failures that may indicate behavioral differences introduced by the framework change.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Connection strings in `appsettings.json` are correct and accessible from the new runtime environment.
- Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify that it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and perform the following checks:

- All pages load without HTTP 500 errors.
- Data is read from and written to the database correctly.
- Authentication and authorization behave as expected, if applicable.
- Static assets (CSS, JavaScript, images) are served correctly.

---

## 8. Review `appsettings.json` and Configuration

Confirm that all configuration previously held in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Deploy to Target Environment

Once local validation is complete, deploy the application to the target environment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the target machine has the appropriate .NET runtime installed:

```bash
dotnet --list-runtimes
```

If the runtime is not present, download and install it from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).