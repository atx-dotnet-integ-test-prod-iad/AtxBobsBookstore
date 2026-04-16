# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Confirm this is consistent across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web`.

---

## 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one to cover critical domain and data logic before deploying.

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Connection strings in `appsettings.json` are accurate for the target environment.
- Run any pending migrations to confirm the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Web Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

---

## 7. Review Platform-Specific Code

Search the solution for any remaining Windows-specific APIs or patterns that may cause issues on non-Windows platforms:

- `System.Web` references (should have been replaced during migration)
- Windows registry access
- Hardcoded Windows file paths using backslashes instead of `Path.Combine`
- `HttpContext.Current` usage (not available in ASP.NET Core)

Use `grep` or Visual Studio's search functionality to locate these patterns if needed.

---

## 8. Review Configuration and Middleware

In `Bookstore.Web`, confirm that the ASP.NET Core middleware pipeline in `Program.cs` (or `Startup.cs`) is correctly configured:

- Authentication and authorization middleware is present if required.
- Static files middleware is enabled.
- Routing and endpoint mapping are correctly defined.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and static assets are present.