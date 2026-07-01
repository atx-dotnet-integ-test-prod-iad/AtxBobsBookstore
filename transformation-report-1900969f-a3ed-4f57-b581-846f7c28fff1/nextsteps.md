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

The steps below describe how to validate, test, and deploy the migrated solution.

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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still within its support window.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, scan the codebase for APIs that are Windows-only. The .NET Compatibility Analyzer can help identify these. Pay particular attention to:

- `System.Web` references (not available on cross-platform .NET)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- `HttpContext` usage patterns that differ from ASP.NET Core

If `System.Web` types were used in `Bookstore.Web`, confirm they have been replaced with their ASP.NET Core equivalents.

---

## 5. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the data access approach is compatible with cross-platform .NET:

- If using **Entity Framework 6**, consider migrating to **Entity Framework Core**, as EF6 has limited cross-platform support.
- If already using **EF Core**, verify the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is present and up to date.
- Run any pending migrations to confirm the database schema is in sync:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test
```

If no tests exist, consider writing basic smoke tests that cover:

- Domain model instantiation (`Bookstore.Domain`)
- Data access queries (`Bookstore.Data`)
- Key HTTP endpoints (`Bookstore.Web`)

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, managing inventory, or any other core features. Check the console output and application logs for runtime exceptions.

---

## 8. Validate Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct values for:

- Database connection strings
- Logging configuration
- Any environment-specific settings that previously resided in `Web.config`

If a `Web.config` was used in the original project, verify that all relevant settings have been migrated to `appsettings.json` or the appropriate ASP.NET Core configuration mechanism.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.