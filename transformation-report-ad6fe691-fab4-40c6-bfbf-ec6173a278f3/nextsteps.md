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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, it is worth adding unit tests for the core logic in `Bookstore.Domain` and integration tests for the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity (`Bookstore.Data`)

If the project uses Entity Framework Core, verify the following:

- The connection string in `appsettings.json` (or `appsettings.Development.json`) is valid and points to the correct database instance.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database schema matches the expected state after migration.

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly on the new .NET runtime:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify the following:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Any authentication or authorization flows behave as expected.

---

## 6. Review `Bookstore.Web` Configuration

Check the following configuration areas in `Bookstore.Web`:

- **`Program.cs`**: Confirm the middleware pipeline and service registrations are correct for the target .NET version.
- **`appsettings.json`**: Verify all environment-specific settings are present and accurate.
- **Static files and Razor views**: Confirm that any static assets and views render correctly, particularly if the project was migrated from Web Forms or an older MVC pattern.

---

## 7. Check for Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Run the .NET Upgrade Assistant compatibility analyzer or the Platform Compatibility Analyzer to identify any runtime-level API usage that may not have surfaced as build errors:

```bash
dotnet add package Microsoft.DotNet.UpgradeAssistant.Extensions.Default.Analyzers
```

Review any reported diagnostics and update the affected code accordingly.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.