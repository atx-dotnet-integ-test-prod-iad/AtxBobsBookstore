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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netcoreapp3.1`, update it to a current long-term support (LTS) version.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or behave differently in cross-platform .NET. Review the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project references `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity`. Run any pending migrations:
  ```bash
  dotnet ef migrations list
  dotnet ef database update
  ```
- **`Bookstore.Web`**: Confirm that any previously used `System.Web` types (e.g., `HttpContext`, `HttpRequest`) have been replaced with their `Microsoft.AspNetCore` equivalents.
- **`Bookstore.Domain`**: Check for any use of `AppDomain`, `BinaryFormatter`, or other types that are restricted or removed in modern .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core business logic:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project exists, consider adding one targeting `Bookstore.Domain` and `Bookstore.Data` to verify critical functionality before deployment.

---

## 6. Run the Application Locally

Start the web application locally to confirm runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- Application starts without exceptions.
- Database connectivity is functional (check connection strings in `appsettings.json`).
- Core user-facing features (browsing, searching, purchasing books) work as expected.
- Any authentication or authorization flows behave correctly.

---

## 7. Review Configuration Files

.NET cross-platform projects use `appsettings.json` instead of `Web.config` or `App.config`. Confirm the following:

- Connection strings have been moved to `appsettings.json` or environment-specific overrides (`appsettings.Production.json`).
- Any `Web.config` transforms or `configSections` have been replaced with the `Microsoft.Extensions.Configuration` pattern.
- Sensitive values (e.g., connection strings, API keys) are not committed to source control and are instead managed via environment variables or a secrets manager.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and configuration files are present before deploying to the target environment.