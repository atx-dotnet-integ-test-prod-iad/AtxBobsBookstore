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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects in the same solution can cause runtime issues even when the build succeeds.

Example of what to look for in each `.csproj`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET compared to .NET Framework. Pay particular attention to:

- **`System.Web` dependencies** — these do not exist in cross-platform .NET. Confirm that `Bookstore.Web` has been fully migrated away from `System.Web` (e.g., `HttpContext`, `HttpRequest`) to their `Microsoft.AspNetCore` equivalents.
- **Entity Framework** — if `Bookstore.Data` uses Entity Framework, confirm it references `Microsoft.EntityFrameworkCore` and not the legacy `EntityFramework` (EF6) package, unless EF6 cross-platform support was intentionally retained.
- **Configuration** — confirm that `Web.config` or `App.config` based configuration has been replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` APIs.

---

## 5. Run Existing Tests

If the solution contains a test project, run the tests to validate core logic:

```bash
dotnet test
```

If no test project currently exists, consider writing basic integration or unit tests for the domain and data layers before deploying.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Core application routes and pages load correctly.
- Any authentication or authorization middleware functions as expected.

---

## 7. Validate Database Migrations

If `Bookstore.Data` uses Entity Framework Core migrations, confirm the migrations are up to date and can be applied cleanly:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations against your target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present, including `appsettings.json` and any static assets.