# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

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

Review the output for any warnings about deprecated or unlisted packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or `netcoreapp3.1`, update it to a current supported version.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to:

- **`System.Web` references** — this namespace is not available in cross-platform .NET. Any remaining usage in `Bookstore.Web` should be replaced with ASP.NET Core equivalents.
- **`HttpContext`**, **`HttpRequest`**, and **`HttpResponse`** — ensure these are accessed via dependency injection rather than static accessors.
- **`ConfigurationManager`** — replace with `Microsoft.Extensions.Configuration` and `appsettings.json`.
- **Entity Framework** — if the project uses Entity Framework 6, consider whether migration to Entity Framework Core is needed, as EF6 has limited support on non-Windows platforms.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify runtime behavior is consistent with the original application.

```bash
dotnet test --configuration Release
```

Review test results for any failures that may indicate behavioral differences introduced by the migration.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` connects to a database, verify the connection string in `appsettings.json` is correctly configured for the target environment and that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is present and up to date.

Run any pending migrations if using Entity Framework Core:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application and manually verify core functionality such as browsing, searching, and any data entry workflows.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and confirm the application loads and operates as expected.

---

## 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, confirm that `Program.cs` (or `Startup.cs` if still present) correctly configures:

- Routing
- Authentication and authorization middleware, if applicable
- Static file serving
- Exception handling

The ordering of middleware in the pipeline can affect behavior, so compare against the original application's configuration where possible.

---

## 9. Check Logging Configuration

Verify that logging is configured correctly in `appsettings.json` and that log output is appearing as expected when running the application. The default provider in ASP.NET Core is `Microsoft.Extensions.Logging`.

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and deployable.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, then deploy to the target server or hosting environment according to your standard deployment process.