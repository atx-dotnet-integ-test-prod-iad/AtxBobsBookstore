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

Review the output for any warnings related to package compatibility or deprecated packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported and consistent version of .NET (for example, `net8.0`). Mixing framework versions across projects in the same solution can cause runtime compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Verify that Entity Framework or any data access layer is using the correct cross-platform NuGet packages (e.g., `Microsoft.EntityFrameworkCore` instead of `System.Data.Entity`).
- **`Bookstore.Web`**: Confirm that any middleware, authentication, or session handling has been updated to use ASP.NET Core equivalents.
- **Configuration**: Ensure `Web.config` or `App.config` settings have been migrated to `appsettings.json` and that `IConfiguration` is being used to read them.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves as expected after migration.

```bash
dotnet test
```

If no test project exists, consider writing basic integration or smoke tests that cover the core data access and web request paths before deploying.

---

## 6. Run the Application Locally

Start the web application locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup with no exceptions in the console output
- Database connectivity (if applicable, run any pending migrations with `dotnet ef database update`)
- Core page routes and any API endpoints load and return expected results
- Authentication and authorization flows work correctly

---

## 7. Verify Database Migrations

If Entity Framework Core is in use, confirm that migrations are up to date and compatible with the target database.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a development or staging database before deploying to production.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Logging and Error Handling

Confirm that logging is configured using `Microsoft.Extensions.Logging` or a compatible provider. Any legacy logging frameworks (e.g., `log4net`, `NLog`) should be verified to have their cross-platform NuGet packages referenced and configured correctly in `Program.cs` or `appsettings.json`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.