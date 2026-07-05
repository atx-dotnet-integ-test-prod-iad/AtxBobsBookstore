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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific APIs

Even without build errors, some APIs used in the original project may be Windows-specific and will fail at runtime on non-Windows platforms. Run the .NET Compatibility Analyzer if it is not already referenced:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any analyzer warnings that surface in the build output.

---

## 5. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct version is referenced. Entity Framework Core is required for cross-platform compatibility. Check the `Bookstore.Data.csproj` for the following:

```xml
<PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.x.x" />
```

If the project previously used Entity Framework 6 (`EntityFramework` package), a migration to EF Core will be necessary. Key differences include:

- Removal of `Database.SetInitializer`
- Replacement of `ObjectContext` with `DbContext`
- Updated LINQ query behavior in certain edge cases

Run any existing EF migrations to confirm they apply cleanly:

```bash
dotnet ef database update
```

---

## 6. Run Unit Tests

If a test project exists in the solution, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

Review test results for any failures that may indicate runtime incompatibilities introduced during the migration.

---

## 7. Run the Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to manually verify:

- Application startup and routing
- Database connectivity and data retrieval
- Any authentication or session-based functionality
- Static file serving (CSS, JS, images)

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains the correct configuration values, particularly connection strings. Legacy projects often stored these in `Web.config`, which is not used in cross-platform .NET.

Confirm that `Web.config` transformation settings have been moved to `appsettings.json` or `appsettings.{Environment}.json` as appropriate.

---

## 9. Validate Middleware and Startup Configuration

If the project was migrated from ASP.NET MVC (Framework) to ASP.NET Core, review `Program.cs` and any `Startup.cs` file to ensure:

- Middleware is registered in the correct order
- Services such as MVC, routing, and authentication are properly configured
- `UseStaticFiles`, `UseRouting`, and `UseAuthorization` are present where needed