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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in modern .NET compared to .NET Framework. Pay particular attention to:

- **`System.Web` dependencies** — these are not available in cross-platform .NET. Confirm that `Bookstore.Web` has been fully migrated away from `System.Web`.
- **Entity Framework** — if `Bookstore.Data` uses Entity Framework, confirm it has been migrated to EF Core and that migrations are up to date.
- **Configuration** — verify that `Web.config` or `App.config` based configuration has been replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` APIs.
- **Authentication/Authorization** — if the application uses ASP.NET Membership or similar, confirm it has been replaced with ASP.NET Core Identity or an equivalent.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate runtime behavior.

```bash
dotnet test
```

If no test project exists, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data`.

---

## 6. Run the Application Locally

Start the web application locally and verify it runs without runtime exceptions.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and exercise the primary workflows, such as browsing books, managing inventory, or any other core features, to confirm expected behavior.

---

## 7. Validate Database Connectivity

If `Bookstore.Data` connects to a database, confirm the following:

- The connection string in `appsettings.json` is correctly configured for the target environment.
- If using EF Core, run any pending migrations against the target database.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Middleware and Startup Configuration

In ASP.NET Core, application startup is configured in `Program.cs` (and optionally `Startup.cs`). Confirm that:

- All required middleware is registered (e.g., routing, authentication, static files).
- Services are registered in the dependency injection container.
- The request pipeline order is correct, as incorrect ordering can cause subtle runtime issues.

---

## 9. Static Files and Bundling

Verify that static assets (CSS, JavaScript, images) are served correctly. In ASP.NET Core, static files must reside in the `wwwroot` folder. If the original project used ASP.NET bundling and minification (`BundleConfig.cs`), confirm this has been replaced with an alternative such as `BundleMinifier` or a front-end build tool.