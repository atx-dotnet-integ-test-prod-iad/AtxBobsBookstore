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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same or compatible framework versions to avoid interoperability issues.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect the code and project files for any remaining Windows-specific APIs or libraries, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `HttpContext` usage from `System.Web` rather than `Microsoft.AspNetCore.Http`

Replace or remove any APIs that are not supported cross-platform.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the URL shown in the console output (typically `http://localhost:5000` or `https://localhost:5001`) and manually verify core functionality such as:

- Page rendering
- Database connectivity via `Bookstore.Data`
- Domain logic behavior via `Bookstore.Domain`

---

## 6. Verify Database Connectivity and Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date and the database schema is correct.

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations are missing or outdated, apply them:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the project was migrated from Entity Framework 6, confirm that the migration to EF Core was handled correctly, as EF Core has breaking differences in behavior and API surface.

---

## 7. Execute Automated Tests

If the solution contains test projects, run them to validate that existing behavior has been preserved after migration.

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences introduced by the framework change rather than pre-existing bugs.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Key areas to check include:

- Connection strings
- Application settings
- Logging configuration
- Authentication settings

The `Web.config` file is not used in ASP.NET Core. All configuration should be handled through `appsettings.json` or environment variables.

---

## 9. Validate Static Files and Bundling

If the application serves static files (CSS, JavaScript, images), confirm they are located in the `wwwroot` directory and are being served correctly. Legacy bundling via `System.Web.Optimization` is not supported in ASP.NET Core and should be replaced with an alternative such as LibMan or a front-end build tool.

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.