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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netcoreapp3.1` or similar outdated targets, update them accordingly and re-run `dotnet restore` and `dotnet build`.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in cross-platform .NET. Review the following areas manually:

- **`System.Web` references**: These are not available in cross-platform .NET. If any remain, they need to be replaced with ASP.NET Core equivalents.
- **`HttpContext`**, **`HttpRequest`**, **`HttpResponse`**: Ensure these are sourced from `Microsoft.AspNetCore.Http` and not `System.Web`.
- **Entity Framework**: If the project uses Entity Framework 6, confirm it has been migrated to Entity Framework Core, or that the EF6 NuGet package for .NET is being used intentionally.
- **Configuration**: Ensure `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration` where applicable.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to migration-related behavioral changes or pre-existing issues.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Core application flows such as browsing, searching, and any authentication function correctly.

---

## 7. Validate Configuration Files

Ensure that `appsettings.json` (and `appsettings.Development.json` if present) contain the correct configuration values that were previously held in `Web.config` or `App.config`. Common items to check:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files, including static assets and configuration files, are present before deploying to the target environment.