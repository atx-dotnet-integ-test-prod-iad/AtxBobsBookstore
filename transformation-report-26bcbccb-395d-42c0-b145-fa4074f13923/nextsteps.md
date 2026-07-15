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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects can cause runtime issues even when the build succeeds.

Example of what to look for in each `.csproj`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay attention to the following areas:

- **`System.Web` references**: These are not available in cross-platform .NET. If any code relied on `System.Web` (e.g., `HttpContext`, `HttpRequest`), confirm it has been replaced with `Microsoft.AspNetCore.Http` equivalents.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been migrated from EF 6 to EF Core and that migrations are up to date.
- **Configuration**: Confirm that `Web.config` or `App.config` usage has been replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` system.

---

## 5. Run Existing Tests

If the solution contains a test project, run the tests to validate core functionality.

```bash
dotnet test
```

If no tests exist, consider writing basic integration or unit tests for the key layers (`Bookstore.Domain` and `Bookstore.Data`) before proceeding further.

---

## 6. Run the Application Locally

Start the web application locally and verify it runs without runtime exceptions.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following at runtime:

- The application starts and the home page loads.
- Database connectivity works (if applicable, run any pending EF Core migrations with `dotnet ef database update`).
- Core user-facing features (browsing, searching, and purchasing books) function as expected.
- Review application logs for any runtime warnings or unhandled exceptions.

---

## 7. Validate Configuration and Environment Settings

Confirm that environment-specific settings are correctly configured in `appsettings.json` and `appsettings.Production.json`. Pay particular attention to:

- Database connection strings.
- Any API keys or external service URLs.
- Logging configuration.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present, including static assets and configuration files.