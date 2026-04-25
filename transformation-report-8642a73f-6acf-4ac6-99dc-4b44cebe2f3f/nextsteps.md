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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid interoperability issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that existed in .NET Framework but have been removed or changed in modern .NET. Common areas to check include:

- `System.Web` references (not available in modern .NET; should be replaced with ASP.NET Core equivalents)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `HttpContext` usage patterns
- Entity Framework 6 vs. Entity Framework Core differences if EF is used in `Bookstore.Data`

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to behavioral differences in modern .NET or legitimate regressions introduced during migration.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The connection string in `appsettings.json` is correctly configured
- Migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is referenced and compatible with the target framework

---

## 7. Run the Web Application Locally

Start the web application to confirm it runs correctly in the new environment:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and manually verify core functionality such as:

- Page rendering
- Data retrieval and display
- Form submissions
- Authentication and authorization flows, if applicable

---

## 8. Review `appsettings.json` Configuration

Confirm that all configuration previously stored in `Web.config` or `App.config` has been properly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Key areas include:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Check Logging Setup

Verify that logging is configured using `Microsoft.Extensions.Logging` and that log output is appearing as expected during local runs. If the legacy project used a third-party logging library (e.g., log4net, NLog), confirm that the modern .NET compatible version is referenced and configured correctly.