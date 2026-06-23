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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config` (connection strings, app settings, etc.).
- Any environment-specific configuration (e.g., `appsettings.Development.json`) is properly set up.
- The `Startup.cs` or `Program.cs` file correctly wires up services, middleware, and configuration sources.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` handles data access, confirm the following:

- The connection string in `appsettings.json` points to the correct database instance.
- If Entity Framework is used, run the following to verify the model and migrations are in a valid state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated, apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checking out) to identify any runtime issues that would not surface during a build.

---

## 6. Check for Runtime Compatibility Issues

Even with a clean build, certain areas may have runtime issues after migration. Pay particular attention to:

- **Authentication and Authorization**: Middleware configuration may differ from the .NET Framework implementation.
- **Static Files**: Ensure `wwwroot` is correctly structured and static file serving is configured in `Program.cs` or `Startup.cs`.
- **Session and Caching**: Verify session state configuration is present and functional if the application relies on it.
- **HTTP Handlers or Modules**: These do not exist in cross-platform .NET. Confirm they have been replaced with the equivalent middleware.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 8. Publish the Application

Once the application has been validated locally, publish it to prepare for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.