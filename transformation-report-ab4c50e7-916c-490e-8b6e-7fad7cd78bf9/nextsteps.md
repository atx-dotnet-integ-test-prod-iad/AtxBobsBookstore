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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay specific attention to:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project references `Microsoft.EntityFrameworkCore` rather than the legacy `System.Data.Entity`. Run any existing database migrations to verify compatibility.
- **`Bookstore.Web`**: If this was previously an ASP.NET Web Forms or ASP.NET MVC (.NET Framework) project, confirm it has been migrated to ASP.NET Core. Check that middleware, routing, authentication, and configuration patterns follow ASP.NET Core conventions.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or threading APIs used still behave as expected under the new runtime.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to catch any runtime regressions.

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic integration tests that cover:

- Database read/write operations via `Bookstore.Data`
- Core domain logic in `Bookstore.Domain`
- Key HTTP endpoints in `Bookstore.Web`

---

## 6. Validate Application Configuration

Review the configuration system. In cross-platform .NET, `Web.config` and `App.config` are replaced by `appsettings.json` and environment variables.

- Confirm that connection strings previously in `Web.config` have been moved to `appsettings.json` or environment-specific configuration files.
- Verify that `IConfiguration` is used to read settings in `Bookstore.Web` and `Bookstore.Data`.

---

## 7. Test the Application Locally

Run the web application locally to confirm it starts and behaves correctly.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify:

- The application starts without runtime exceptions.
- Pages or API endpoints return expected responses.
- Database connectivity is functional.
- Any authentication or authorization flows work as intended.

---

## 8. Review Deprecated Package References

Run the following command to identify any outdated NuGet packages that may have known issues on modern .NET.

```bash
dotnet list package --outdated
```

Update packages where appropriate, particularly those related to data access, logging, and web middleware.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required assemblies, static assets, and configuration files are present.