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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate compatibility concerns introduced during migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were available in .NET Framework but have been removed or altered in modern .NET. Common areas to check include:

- `System.Web` references (not available in modern .NET; should be replaced with `Microsoft.AspNetCore.*`)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `HttpContext` usage patterns
- Any Windows-specific APIs if cross-platform support is required

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool if a deeper API audit is needed.

---

## 5. Run Existing Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and modern .NET rather than logic errors.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, verify the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is the correct version for the target framework.
- Connection strings in configuration files (`appsettings.json`) are correct and accessible in the new project structure.
- Run any pending migrations or verify the schema is consistent:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally to perform end-to-end validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that:

- Pages load without errors
- Data is read from and written to the database correctly
- Authentication and authorization flows work as expected, if applicable

Check the application logs for any runtime exceptions that would not have surfaced during the build phase.

---

## 8. Review Configuration Files

Confirm that all configuration previously held in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` and that environment-specific settings (e.g., `appsettings.Development.json`) are in place.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, static assets, and dependencies are present before deploying to the target environment.