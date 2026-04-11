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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process, particularly around package version conflicts or unsupported target frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns that were not caught as hard errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Review the following areas manually:

- **`Bookstore.Data`**: Confirm that any Entity Framework usage has been migrated from `EntityFramework` (EF6) to `Microsoft.EntityFrameworkCore`. Check that database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are referenced and configured correctly.
- **`Bookstore.Web`**: Confirm that any `System.Web` dependencies have been replaced with their ASP.NET Core equivalents. This includes HTTP context access, authentication, session handling, and routing.
- **`Bookstore.Domain`**: Verify that any serialization, configuration, or reflection-based code functions as expected under cross-platform .NET.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test
```

If no tests currently exist, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following:

- Application starts without runtime exceptions
- Database connectivity works as expected (run any pending migrations if using EF Core: `dotnet ef database update`)
- Core application workflows such as browsing, searching, and any data entry forms function correctly

---

## 7. Validate Configuration Files

Check `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) to ensure:

- Connection strings are correct and use the appropriate format for the target database
- Any configuration keys previously stored in `Web.config` or `App.config` have been moved to the appropriate `appsettings.json` sections
- Sensitive values are not hardcoded and are handled via environment variables or a secrets manager

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and dependencies are present.