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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may still use Windows-specific APIs (e.g., the registry, `System.Windows.Forms`, or `System.Drawing` GDI+) that will fail at runtime on non-Windows platforms.

Use the .NET Compatibility Analyzer to surface any such issues:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Address any `CA1416` platform compatibility warnings that appear.

---

## 5. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that the data access technology has been migrated appropriately:

- If the project used **Entity Framework 6**, verify whether it has been migrated to **Entity Framework Core**.
- Confirm the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is referenced and up to date.
- Run any pending migrations or verify the schema is compatible:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checkout) to confirm runtime behavior is correct.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether they are caused by behavioral changes introduced during migration or by pre-existing issues.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Production.json`) contain the correct configuration values, particularly:

- **Connection strings** — previously in `Web.config`, these must now reside in `appsettings.json` or environment variables.
- **Authentication settings** — any forms authentication or membership provider configuration must be replaced with ASP.NET Core equivalents.

Example connection string format in `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.;Database=Bookstore;Trusted_Connection=True;"
  }
}
```

---

## 9. Validate Static Files and Bundling

If the project used **System.Web.Optimization** (BundleConfig) for CSS and JavaScript bundling, confirm this has been replaced with a supported alternative such as the ASP.NET Core built-in static file middleware or a tool like **LibMan** or **npm** with a bundler.

Verify that all static assets load correctly when running the application locally.

---

## 10. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder and confirm all required files are present before deploying to the target environment.