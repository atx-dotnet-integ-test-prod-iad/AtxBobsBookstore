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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

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

## 3. Review Target Framework Monikers

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform version, such as `net8.0`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a specific reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Use the .NET Compatibility Analyzer or review the project dependencies manually to identify any libraries or APIs that are Windows-only. Common areas to check include:

- `System.Web` references (not available in cross-platform .NET)
- Windows Registry access
- Windows-specific authentication or identity libraries
- Any remaining `packages.config` files that were not migrated to `PackageReference`

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the local URL provided in the terminal output and verify that the application loads and behaves as expected.

---

## 6. Verify Data Layer Functionality

If `Bookstore.Data` uses Entity Framework or another ORM, confirm the following:

- The database connection string is correctly configured in `appsettings.json` or environment variables.
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- Data reads and writes function correctly through the application.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior:

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral differences introduced during the migration.

---

## 8. Validate Configuration Files

Review `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) to confirm:

- Connection strings are correct and accessible.
- Any configuration keys previously stored in `Web.config` have been properly migrated.
- Logging, authentication, and middleware settings are accurate.

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.