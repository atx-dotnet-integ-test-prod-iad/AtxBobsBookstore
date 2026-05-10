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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or `netstandard2.0`, update it accordingly and re-run the build.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, inspect each project for any remaining Windows-specific APIs or libraries, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- COM interop

These will not function on Linux or macOS. Replace them with cross-platform alternatives where applicable.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the URL shown in the console output (typically `https://localhost:5000` or similar) and verify the application loads and core functionality works.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is correct for your environment.
- Any pending migrations are applied.

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the project was migrated from Entity Framework 6, confirm that the migration to EF Core was completed and that all `DbContext` configurations are valid.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run all tests to validate correctness of the migrated code.

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral differences introduced during the migration. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web -c Release -o ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web -c Release -r linux-x64 --self-contained true -o ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.