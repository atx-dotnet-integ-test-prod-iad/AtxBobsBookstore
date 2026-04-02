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

Example of what to look for:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET compared to .NET Framework. Pay particular attention to:

- **`System.Web` dependencies** — these are not available in cross-platform .NET. Confirm that `Bookstore.Web` has been fully migrated away from `System.Web` (e.g., to `Microsoft.AspNetCore`).
- **Entity Framework** — if `Bookstore.Data` uses Entity Framework, confirm it has been migrated from EF 6 to EF Core and that the database provider package is correct.
- **Configuration** — confirm that `Web.config` or `App.config` usage has been replaced with `appsettings.json` and `IConfiguration`.
- **Authentication/Authorization** — confirm any `FormsAuthentication` or similar legacy mechanisms have been replaced with ASP.NET Core equivalents.

---

## 5. Run Unit Tests

If the solution contains a test project, run the tests to validate core logic has not regressed.

```bash
dotnet test
```

If no test project exists, consider writing basic tests for the domain and data layers to verify expected behavior before deploying.

---

## 6. Run the Application Locally

Start the web application locally and navigate through its key functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following:

- Application starts without runtime exceptions.
- Database connectivity works as expected (run any pending migrations if using EF Core).
- Key pages and endpoints return correct responses.
- Static files (CSS, JS, images) are served correctly.

If using EF Core, apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Review Application Logs

After running locally, review the application logs for any runtime warnings or errors that would not have surfaced during the build. Look specifically for:

- Middleware configuration issues.
- Missing service registrations in `Program.cs` or `Startup.cs`.
- Serialization or deserialization errors.
- Database query failures.

---

## 8. Validate Configuration for the Target Environment

Before deploying to a staging or production environment, confirm the following:

- `appsettings.json` and any environment-specific overrides (e.g., `appsettings.Production.json`) contain the correct values.
- Connection strings are updated for the target environment.
- Any secrets are managed through a secure mechanism such as environment variables or a secrets manager, not hardcoded in configuration files.

---

## 9. Publish the Application

Once local validation is complete, publish the application for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present before copying them to the target server.