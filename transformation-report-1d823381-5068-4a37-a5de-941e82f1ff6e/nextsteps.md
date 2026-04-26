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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or `netcoreapp3.1`, update it to a current supported version.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to:

- **`System.Web` dependencies** — these are not available in cross-platform .NET. Ensure `Bookstore.Web` has fully migrated to ASP.NET Core equivalents.
- **Entity Framework** — if `Bookstore.Data` uses Entity Framework 6, confirm it has been migrated to Entity Framework Core or that the EF6 cross-platform NuGet package is in use.
- **Configuration** — legacy `Web.config` or `App.config` usage should be replaced with `appsettings.json` and `IConfiguration`.
- **HTTP Modules and Handlers** — these must be replaced with ASP.NET Core middleware.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the migration rather than pre-existing bugs.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- Application starts without exceptions.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Core application flows such as browsing, searching, and purchasing books function correctly.
- Authentication and authorization behave as expected if applicable.

---

## 7. Review Logging and Exception Handling

Run the application and observe the logs for any runtime exceptions or deprecation warnings that would not surface at compile time. Ensure the logging configuration in `Program.cs` or `Startup.cs` is properly set up using `Microsoft.Extensions.Logging`.

---

## 8. Validate Database Migrations

If Entity Framework Core is in use, confirm that all migrations are up to date and apply cleanly against the target database.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once the application has been validated locally, publish it to a folder for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.