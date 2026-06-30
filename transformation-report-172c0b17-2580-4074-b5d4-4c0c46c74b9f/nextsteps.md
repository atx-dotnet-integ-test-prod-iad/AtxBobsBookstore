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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings that may indicate deprecated APIs or framework incompatibilities.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netcoreapp3.1`, update it accordingly and re-run the build.

---

## 4. Run Unit Tests

If the solution contains any test projects, execute them to validate that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test output for any failures that may have been introduced during the migration.

---

## 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target environment.
- If Entity Framework Core is in use, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any authentication flows, to confirm they function correctly.

---

## 7. Check for Removed or Changed APIs

Review the code in all three projects for usage of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Common areas to check include:

- `System.Web` references, which are not available in modern .NET and should be replaced with `Microsoft.AspNetCore` equivalents.
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core.
- Any use of `ConfigurationManager`, which should be replaced with `IConfiguration` from `Microsoft.Extensions.Configuration`.

---

## 8. Review Startup and Configuration

In ASP.NET Core, application startup and configuration are handled differently than in .NET Framework. Confirm that:

- `Program.cs` uses the modern minimal hosting model or the `WebApplication.CreateBuilder` pattern.
- Middleware is registered in the correct order within the request pipeline.
- Dependency injection is configured properly for services defined in `Bookstore.Domain` and `Bookstore.Data`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify that all required assets, configuration files, and binaries are present before deploying to the target environment.