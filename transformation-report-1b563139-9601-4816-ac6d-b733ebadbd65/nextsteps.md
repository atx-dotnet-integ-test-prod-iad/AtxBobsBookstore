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

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the build.

---

## 4. Check for Windows-Specific APIs

Even when a project builds successfully, it may still contain Windows-specific API calls that will fail at runtime on non-Windows platforms. Use the .NET compatibility analyzer to surface these issues.

```bash
dotnet build --configuration Release /p:PlatformTarget=AnyCPU
```

Pay particular attention to:
- `System.Web` references (not supported on cross-platform .NET)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-only file path assumptions

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate runtime behavior.

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate runtime incompatibilities not caught at compile time.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, verify that:

- The connection string in `appsettings.json` (or equivalent) is correctly configured for the target environment.
- Entity Framework Core migrations (if applicable) are up to date.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If the project previously used Entity Framework 6, confirm it has been migrated to **Entity Framework Core**, as EF6 does not fully support cross-platform .NET.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output and confirm that:
- Pages load without errors
- Database reads and writes function correctly
- Authentication and authorization behave as expected (if applicable)

---

## 8. Review `appsettings.json` and Configuration

Ensure that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Key areas to check:

- Connection strings
- Application settings
- Logging configuration

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

Verify the contents of the `./publish` directory before deploying to the target environment.