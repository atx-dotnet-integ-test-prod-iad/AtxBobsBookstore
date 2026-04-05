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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Make sure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a specific reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Review the dependencies in each project for any packages or APIs that are Windows-only. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET
- Windows Registry access
- Windows-specific authentication providers
- Any remaining `packages.config` files that were not migrated to `PackageReference`

Run the .NET Upgrade Assistant compatibility analyzer if any uncertainty exists:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze .
```

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved after migration:

```bash
dotnet test --configuration Release
```

Review test output carefully. Any failures may indicate behavioral differences between the legacy framework and the new target framework.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, verify the following:

- The connection string format is compatible with the version of Entity Framework or ADO.NET being used
- Any database migrations are up to date by running:

```bash
dotnet ef database update
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) targets the correct version aligned with your runtime

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs correctly on a non-Windows platform if cross-platform execution is a goal:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following during local validation:

- All pages and routes load without errors
- Authentication and authorization behave as expected
- Static assets are served correctly
- Logging output does not show unhandled exceptions on startup

---

## 8. Review Configuration Files

Ensure that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Production.json`) are present and correctly structured. Legacy `Web.config` or `App.config` values should have been migrated to the `appsettings.json` format. Confirm that:

- Connection strings are present under the `ConnectionStrings` section
- Any custom configuration sections have been converted to strongly-typed options classes using `IOptions<T>`

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, assemblies, and static assets are present before deploying to the target environment.