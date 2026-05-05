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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing framework versions between projects can cause runtime issues even when the build succeeds.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not available or have changed in cross-platform .NET. Review the following areas manually:

- **`Bookstore.Data`**: Confirm that the Entity Framework or data access layer is using a compatible provider (e.g., `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity`).
- **`Bookstore.Web`**: Confirm that any middleware, authentication, or HTTP pipeline configuration has been updated to use ASP.NET Core conventions.
- **`Bookstore.Domain`**: Check for any use of `System.Web`, `AppDomain`, or other .NET Framework-specific namespaces that may have been silently replaced or removed.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data layer behavior.

```bash
dotnet test
```

If no test project exists, consider writing basic integration or unit tests for the core domain and data layers before deploying.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following:

- The application starts without exceptions.
- Database connections are established successfully (check connection strings in `appsettings.json`).
- Core application routes and pages load as expected.
- Any authentication or authorization flows work correctly.

---

## 7. Review Configuration Files

.NET cross-platform projects use `appsettings.json` instead of `Web.config` or `App.config`. Confirm that:

- All connection strings have been moved to `appsettings.json`.
- Environment-specific settings are handled using `appsettings.Development.json` and `appsettings.Production.json`.
- No sensitive values are hardcoded in configuration files.

---

## 8. Validate Database Migrations

If Entity Framework Core is being used, confirm that migrations are up to date and can be applied to the target database.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.