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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

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

Verify that all three projects build without warnings or errors. Pay attention to any warnings about obsolete APIs or framework-specific members that may have been carried over from the legacy project.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to validate that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Validate Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations apply cleanly:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Configuration**: Confirm that `appsettings.json` contains all necessary configuration values (connection strings, API keys, etc.) that may have previously lived in `Web.config` or `App.config`.
- **Static assets and routing**: Navigate through the application in a browser and confirm pages load correctly and routes resolve as expected.

---

## 5. Review Replaced or Removed APIs

Cross-platform .NET does not support certain Windows-specific or legacy APIs. Review the codebase for any of the following that may have been silently replaced or stubbed during transformation:

- `System.Web` references (replaced by `Microsoft.AspNetCore`)
- `HttpContext` usage patterns specific to ASP.NET (classic)
- `ConfigurationManager` (replaced by `IConfiguration`)
- Windows-only libraries or P/Invoke calls

Use the .NET Upgrade Assistant compatibility analyzer or the following command to surface remaining compatibility concerns:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 6. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended cross-platform version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project is still referencing `net48` or another Windows-only framework moniker unless intentionally required.

---

## 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and assets are present before deploying to the target environment.