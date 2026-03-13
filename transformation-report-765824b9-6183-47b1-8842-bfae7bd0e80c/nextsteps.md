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

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review the NuGet packages and any `using` directives across all three projects for APIs that are Windows-only. Common areas to check include:

- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)
- Windows Registry access
- COM interop references
- Any package with `<RuntimeIdentifier>win-x64</RuntimeIdentifier>` constraints

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate that business logic and data access behavior are preserved after migration.

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project exists, consider writing basic tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before proceeding further.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, verify the following:

- The EF Core provider package is correct for your database (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Run any pending migrations against a development database.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm the connection string in `appsettings.json` is valid for the target environment.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary workflows to confirm that routing, data access, and rendering all function as expected.

---

## 8. Review `appsettings.json` and Environment Configuration

Confirm that environment-specific settings such as connection strings, logging levels, and any API keys are correctly configured in:

- `appsettings.json`
- `appsettings.Development.json`
- `appsettings.Production.json`

Ensure sensitive values are not hardcoded and are instead sourced from environment variables or a secrets manager.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is self-contained and correct.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target server.