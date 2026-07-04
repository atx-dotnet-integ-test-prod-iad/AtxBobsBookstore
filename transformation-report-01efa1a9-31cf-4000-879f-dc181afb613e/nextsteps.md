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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing target frameworks between projects (e.g., `net6.0` in one and `net8.0` in another) can cause runtime compatibility issues.

---

## 4. Verify Configuration Files

Check that `appsettings.json` (and `appsettings.Development.json` if present) in `Bookstore.Web` contains all necessary configuration values, including:

- Database connection strings
- Any application-specific settings previously stored in `Web.config` or `App.config`

Legacy `Web.config` or `App.config` values are not automatically read in .NET. Ensure they have been migrated to `appsettings.json` or environment variables.

---

## 5. Validate the Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- The `DbContext` is properly registered in the dependency injection container within `Bookstore.Web`.
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm expected behavior.

---

## 7. Check for Runtime Compatibility Issues

Pay attention to the following areas that commonly surface runtime issues after migration:

- **Authentication/Authorization**: Middleware configuration in .NET differs from the old OWIN pipeline.
- **Session and Caching**: Ensure `AddSession` and `AddDistributedMemoryCache` are configured in `Program.cs` if sessions are used.
- **Static Files**: Confirm `UseStaticFiles()` is called in the middleware pipeline if the application serves static assets.
- **HTTP Pipeline Order**: Middleware order in `Program.cs` matters. Ensure `UseAuthentication()` is called before `UseAuthorization()`.

---

## 8. Execute Existing Tests

If the solution contains test projects, run them to verify that business logic and data access behavior remain correct after the migration.

```bash
dotnet test
```

Review any failing tests and determine whether they reflect genuine regressions or test code that itself requires updating for .NET compatibility.

---

## 9. Deploy to the Target Environment

Once local validation is complete, publish the application for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment. Ensure the target environment has the correct .NET runtime version installed.

```bash
dotnet --list-runtimes
```