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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Compatibility

Check that any APIs used in the project are supported on cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Confirm that the database provider (e.g., Entity Framework Core) is correctly configured and that connection strings are environment-appropriate.
- **`Bookstore.Web`**: Verify that middleware, authentication, and any HTTP modules or handlers that existed in the legacy project have been correctly replaced with their ASP.NET Core equivalents.
- **`Bookstore.Domain`**: Ensure no platform-specific types or serialization mechanisms are in use.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to identify any remaining compatibility concerns.

---

## 4. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console output and application logs for any unhandled exceptions or configuration errors.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality is preserved.

```bash
dotnet test
```

Review any failing tests and determine whether they indicate a regression introduced during migration or a test that requires updating due to API changes.

If no test projects exist, consider adding unit tests for the core domain logic in `Bookstore.Domain` and integration tests for the data access layer in `Bookstore.Data`.

---

## 6. Validate Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, verify that migrations are up to date and can be applied cleanly.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations to a local or staging database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all required configuration values, including:

- Database connection strings
- Any API keys or external service endpoints
- Logging configuration

Confirm that secrets are not stored directly in source-controlled configuration files. Use `dotnet user-secrets` for local development or environment variables for production.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output is complete before deploying to the target environment.