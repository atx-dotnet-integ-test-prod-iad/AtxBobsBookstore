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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp3.1`, `net5.0`, or `net6.0`, update it to `net8.0` and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Even without build errors, runtime issues can arise from APIs that changed behavior between .NET Framework and modern .NET. Pay particular attention to:

- **`System.Web` dependencies** — these are not available in modern .NET. Ensure `Bookstore.Web` has fully migrated to ASP.NET Core equivalents.
- **Entity Framework** — confirm that `Bookstore.Data` is using EF Core and not the legacy `EntityFramework` (EF6) NuGet package, unless EF6 on .NET is intentionally being used.
- **Configuration** — verify that `Web.config` or `App.config` based configuration has been replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` APIs.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate core functionality.

```bash
dotnet test --configuration Release
```

Review test results for any failures that may indicate behavioral differences introduced during migration.

---

## 6. Manual Smoke Testing

Start the web application locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Test the following areas at a minimum:

- Application startup and home page load
- Database connectivity (if `Bookstore.Data` uses a database, confirm the connection string in `appsettings.json` is correct)
- Core user-facing features such as browsing, searching, and any CRUD operations

---

## 7. Database Migration Validation

If `Bookstore.Data` uses EF Core migrations, verify the migrations are up to date and apply them to a test database.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj

dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that the schema matches expectations and no data loss has occurred.

---

## 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to confirm:

- Middleware is registered in the correct order
- Authentication and authorization, if used, are configured with ASP.NET Core equivalents
- Static files, routing, and error handling middleware are present

---

## 9. Publish the Application

Once validation is complete, publish the application to a folder for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files, including `appsettings.json` and static assets, are present before deploying to the target environment.