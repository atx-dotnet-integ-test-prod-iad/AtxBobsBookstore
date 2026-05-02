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

Ensure the output shows **0 Error(s)** for all three projects before moving forward.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly and re-run the build.

---

## 4. Check for Runtime Compatibility Issues

Some APIs available in .NET Framework are not available or behave differently in cross-platform .NET. Review the following areas manually:

- **`Bookstore.Data`**: Confirm that the database provider (e.g., Entity Framework Core) is configured correctly and that any connection strings are valid for the target environment.
- **`Bookstore.Web`**: Verify that any middleware, authentication configuration, or HTTP pipeline setup follows ASP.NET Core conventions rather than legacy `System.Web` patterns.
- **`Bookstore.Domain`**: Check for any use of `AppDomain`, `BinaryFormatter`, or other APIs that are restricted or removed in modern .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the domain and data layers to verify expected behavior after migration.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, placing an order) to verify end-to-end functionality.

---

## 7. Validate Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of sync, generate a new migration and apply it to a local database:

```bash
dotnet ef migrations add PostMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all required configuration values (connection strings, logging settings, etc.) and that no configuration is still being read from `Web.config` or `App.config`, as these are not used in ASP.NET Core.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy it to the target hosting environment (e.g., IIS, Linux server with Kestrel, or Azure App Service).