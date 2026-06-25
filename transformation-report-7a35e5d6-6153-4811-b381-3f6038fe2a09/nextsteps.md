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

The steps below describe how to validate, test, and deploy the migrated solution.

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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may still use Windows-specific APIs that will fail at runtime on non-Windows platforms. Run the .NET Compatibility Analyzer to surface any such issues.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Pay particular attention to `Bookstore.Data` if it uses anything related to `System.Data`, MSMQ, WCF, or Windows Registry access.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that the migrated logic behaves correctly.

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects exist, consider writing targeted unit tests for the domain and data layers before proceeding further.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework, verify the following:

- The EF Core provider package is correct for your database (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed URL and confirm that the application loads, connects to the database, and core functionality works as expected.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains the correct configuration values for the target environment. Legacy `Web.config` or `App.config` values may not have been fully migrated.

- Connection strings
- Application settings
- Logging configuration

Cross-reference any remaining `.config` files in the solution to confirm nothing critical was omitted during transformation.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy it to the target host environment.