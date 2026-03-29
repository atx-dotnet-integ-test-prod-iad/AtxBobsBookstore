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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Data Layer (`Bookstore.Data`)

- If the project uses **Entity Framework**, confirm the correct version of EF Core is referenced (not the legacy `EntityFramework` package).
- Run any existing **database migrations** to verify they are compatible:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If migrations do not exist yet, generate an initial migration and inspect it before applying:

```bash
dotnet ef migrations add InitialMigration
```

---

## 4. Validate the Domain Layer (`Bookstore.Domain`)

- Review all domain models and ensure no types rely on assemblies that are not available in cross-platform .NET (e.g., `System.Web`, `System.Drawing` without the appropriate NuGet package).
- Run any unit tests targeting the domain layer:

```bash
dotnet test
```

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Confirm the project runs locally:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Open the application in a browser and navigate through the primary workflows (browsing, searching, and any authentication flows if present).
- Check that configuration values previously stored in `Web.config` have been correctly migrated to `appsettings.json`. Pay particular attention to:
  - Connection strings
  - Application settings keys
  - Authentication/authorization configuration

---

## 6. Review Middleware and HTTP Pipeline

If the web project previously used **ASP.NET (System.Web)** and has been migrated to **ASP.NET Core**, verify the following in `Program.cs` or `Startup.cs`:

- Static file serving is configured (`app.UseStaticFiles()`).
- Routing is correctly set up (`app.UseRouting()`, `app.MapControllers()` or `app.MapRazorPages()`).
- Any custom HTTP modules or handlers from the legacy project have been replaced with the equivalent ASP.NET Core middleware.

---

## 7. Run the Full Test Suite

If the solution contains test projects, execute all tests and review results:

```bash
dotnet test --configuration Release --logger trx
```

Investigate any failing tests to determine whether they reflect regressions introduced during migration or pre-existing issues.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all expected files are present, including static assets and configuration files.

---

## 9. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-framework compatibility issues at runtime.