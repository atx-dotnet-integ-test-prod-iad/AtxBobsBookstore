# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

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

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under modern .NET.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations or database configurations are functioning correctly.

If using Entity Framework Core, verify the connection string in your configuration file (`appsettings.json`) is correct for your target environment, then apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If the project was previously using Entity Framework 6 (EF6), confirm it has been migrated to Entity Framework Core, as EF6 does not support cross-platform .NET. Check that all `DbContext` configurations, relationships, and queries are compatible with EF Core behavior.

---

## 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify the following:

- Pages load without errors
- Data is read from and written to the database correctly
- Any authentication or authorization flows behave as expected

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- Settings have been moved to `appsettings.json` or environment variables
- Any `Web.config` transforms or `system.web` configurations have been replaced with the appropriate ASP.NET Core middleware and configuration equivalents
- Connection strings, logging settings, and environment-specific values are correctly defined

---

## 7. Check for Platform-Specific Code

Review the codebase for any remaining usage of Windows-specific APIs or libraries that may not be available cross-platform. Common areas to check include:

- Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions
- COM interop or P/Invoke calls
- `System.Drawing` usage, which requires additional native dependencies on Linux and macOS

---

## 8. Validate Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects to avoid compatibility issues between referenced assemblies.