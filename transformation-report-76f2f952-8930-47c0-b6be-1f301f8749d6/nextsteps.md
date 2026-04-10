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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Compatibility

Check for any APIs used in the codebase that existed in .NET Framework but behave differently or are absent in cross-platform .NET. Common areas to inspect include:

- **`System.Web`** references — these are not available in cross-platform .NET. Ensure all such usages have been replaced with ASP.NET Core equivalents.
- **`ConfigurationManager`** — replace with `Microsoft.Extensions.Configuration`.
- **`HttpContext`** — ensure usage is through ASP.NET Core's `IHttpContextAccessor` or controller context.
- **Entity Framework** — confirm the project is using EF Core rather than EF 6 if a migration was intended.

---

## 4. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows such as browsing books, managing data, and any authentication flows if present.

---

## 5. Check Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that the database connection string in `appsettings.json` is correctly configured for the target environment.

Apply any pending migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 6. Execute Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to behavioral differences in cross-platform .NET or pre-existing issues.

---

## 7. Review `appsettings.json` and Environment Configuration

Confirm that all configuration values previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 8. Publish the Application

Once the application has been validated locally, publish it to prepare for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.