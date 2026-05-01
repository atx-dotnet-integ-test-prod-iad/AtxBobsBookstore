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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Data Layer (`Bookstore.Data`)

- If the project uses Entity Framework, verify that the correct EF Core version is referenced (not the legacy `EntityFramework` package).
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, scaffold them from the current model:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Validate the Domain Layer (`Bookstore.Domain`)

- Review all domain models and business logic classes for any usage of APIs that were available in .NET Framework but are absent or changed in modern .NET (e.g., `System.Web`, `AppDomain`, serialization attributes).
- Run any unit tests targeting the domain layer:

```bash
dotnet test
```

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Confirm that the project is targeting the correct ASP.NET Core version in the `.csproj` file.
- Check `Program.cs` and `Startup.cs` (if present) for correct middleware configuration.
- Verify that configuration previously handled by `Web.config` has been migrated to `appsettings.json`. Pay particular attention to:
  - Connection strings
  - Application settings
  - Authentication configuration
- Run the application locally and navigate through the primary workflows:

```bash
dotnet run --project Bookstore.Web
```

---

## 6. Review Static Files and Bundling

- ASP.NET Core does not use `BundleConfig.cs` or the legacy `System.Web.Optimization` library. Confirm that static file serving is configured in the middleware pipeline and that any bundling/minification has been replaced with a supported alternative such as `LibMan` or a front-end build tool.

---

## 7. Check Authentication and Authorization

- If the application previously used ASP.NET Membership or `FormsAuthentication`, verify these have been replaced with ASP.NET Core Identity or cookie authentication middleware, as those legacy systems are not available in modern .NET.

---

## 8. Run the Full Test Suite

Execute all tests across the solution to confirm functional correctness after migration:

```bash
dotnet test --configuration Release --logger trx
```

Review the `.trx` output files for any failing tests and address failures before proceeding to deployment.

---

## 9. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, then deploy the output to your target hosting environment (IIS, Azure App Service, or a self-hosted environment supporting .NET).