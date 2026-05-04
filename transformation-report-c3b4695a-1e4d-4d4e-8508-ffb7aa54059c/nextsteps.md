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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure consistency across all three projects so there are no framework mismatches between dependencies.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Review the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the EF Core version is compatible and that any database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are updated.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC project, confirm that middleware configuration in `Program.cs` or `Startup.cs` follows the current ASP.NET Core conventions.
- **`Bookstore.Domain`**: Check for any use of `System.Web` or other Windows-specific namespaces that may have been silently replaced or stubbed out.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data layer behavior.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the domain and data layers before proceeding to deployment.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Confirm the following:

- The application starts without runtime exceptions.
- Database connections (if applicable) are established correctly.
- Core pages and routes load as expected.
- Any authentication or session handling works correctly.

---

## 7. Validate Configuration Files

Check `appsettings.json` and any environment-specific variants (e.g., `appsettings.Development.json`) to ensure:

- Connection strings are correct for the target environment.
- Any settings previously stored in `Web.config` have been migrated to `appsettings.json`.
- Logging configuration is present and appropriate.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.

---

## 9. Verify on Target Operating System

Since the goal of this migration was cross-platform compatibility, if the deployment target is Linux or macOS, run the published output on that platform to confirm there are no OS-specific issues such as:

- File path casing sensitivity.
- Windows-specific APIs that were not caught at compile time.
- Differences in environment variable handling.