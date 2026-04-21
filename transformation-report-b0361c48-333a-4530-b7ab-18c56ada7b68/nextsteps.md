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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build:

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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing framework versions between projects can cause runtime issues even when the build succeeds.

---

## 4. Check for Removed or Changed APIs

Legacy .NET Framework projects often rely on APIs that have been removed or changed in cross-platform .NET. Review the following areas manually:

- **`System.Web` dependencies** — This namespace is not available in .NET Core or later. If any references remain, they must be replaced with ASP.NET Core equivalents.
- **`HttpContext`** — Ensure usage has been updated to the ASP.NET Core `HttpContext`.
- **`ConfigurationManager`** — Replace with `Microsoft.Extensions.Configuration`.
- **`EntityFramework` (classic)** — If the project used EF6, confirm it has been migrated to EF Core or that the EF6 NuGet package for .NET is referenced explicitly.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding.

---

## 6. Validate Database Connectivity

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- The connection string in `appsettings.json` is correctly configured for the target environment.
- If using EF Core, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database schema matches what the application expects.

---

## 7. Run the Application Locally

Start the web application locally to perform end-to-end validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Authentication and authorization (if present) function as expected.

---

## 8. Review Application Logs

Check the application logs during local execution for any runtime exceptions or deprecation warnings that would not surface at build time. Configure logging in `appsettings.json` if not already present:

```json
"Logging": {
  "LogLevel": {
    "Default": "Information",
    "Microsoft.AspNetCore": "Warning"
  }
}
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files, static assets, and configuration files are present before deploying to the target environment.