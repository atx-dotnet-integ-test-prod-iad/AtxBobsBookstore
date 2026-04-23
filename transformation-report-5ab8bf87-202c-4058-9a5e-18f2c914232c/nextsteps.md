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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Even without build errors, runtime issues can arise from APIs that were removed or changed in modern .NET. Pay particular attention to:

- **`System.Web` dependencies** — this namespace is not available in .NET Core or later. If `Bookstore.Web` previously used `System.Web` (e.g., `HttpContext`, `HttpRequest`), verify that these have been replaced with their `Microsoft.AspNetCore` equivalents.
- **Entity Framework** — if `Bookstore.Data` uses Entity Framework, confirm it has been migrated from `EntityFramework` (EF6) to `Microsoft.EntityFrameworkCore` if that was intended.
- **Configuration** — usage of `System.Configuration.ConfigurationManager` should be replaced with `Microsoft.Extensions.Configuration`.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. If no test project exists, consider writing basic integration or unit tests for the domain and data layers before proceeding.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and exercise the primary features, including any database reads and writes, to confirm end-to-end functionality.

---

## 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that your connection string is correctly configured in `appsettings.json` and that any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If you are not using EF migrations, confirm that the database schema is compatible with the updated data access layer.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy it to your target hosting environment (IIS, Linux server, Azure App Service, etc.).