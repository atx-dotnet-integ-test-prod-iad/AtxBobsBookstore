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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still within its support window.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework Core), verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are present and up to date. Run the following to apply migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist or are outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute all tests to verify functional correctness:

```bash
dotnet test --configuration Release
```

If no tests exist, consider writing basic smoke tests that cover:

- Domain model construction and validation logic in `Bookstore.Domain`
- Repository or data access methods in `Bookstore.Data`
- Key HTTP endpoints in `Bookstore.Web`

---

## 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at runtime:

- The application starts without exceptions in the console output.
- Database connectivity is established successfully.
- Key pages or API endpoints return expected responses.
- Any static assets (CSS, JavaScript) are served correctly.

---

## 7. Check for Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` compatibility tooling to identify any runtime-level compatibility issues that do not surface as build errors, such as:

- Use of `System.Web` types that may have been shimmed during transformation
- `ConfigurationManager` usage replaced by `Microsoft.Extensions.Configuration`
- Windows-only APIs that may fail on non-Windows platforms

---

## 8. Review Application Configuration

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all configuration values previously held in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify all expected files are present before deploying to the target environment.