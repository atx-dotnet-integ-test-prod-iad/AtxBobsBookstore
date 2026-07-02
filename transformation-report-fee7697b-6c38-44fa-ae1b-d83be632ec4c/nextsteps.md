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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that the business logic and data access layers behave as expected after migration.

```bash
dotnet test
```

If no test projects currently exist, consider writing tests that cover:
- Domain model validation logic in `Bookstore.Domain`
- Repository or data access methods in `Bookstore.Data`
- Controller actions and middleware behavior in `Bookstore.Web`

---

## 4. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The connection string in `appsettings.json` is correctly configured for the target database.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web
```

Check the following:
- The application starts without runtime exceptions.
- All pages and API endpoints load correctly.
- Authentication and authorization flows work as expected, if applicable.
- Static assets (CSS, JavaScript, images) are served correctly.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm that:

- All configuration values previously in `Web.config` have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Environment-specific settings (e.g., connection strings, API keys) are handled using environment variables or the appropriate `appsettings` file.
- The `Program.cs` or `Startup.cs` correctly reads and applies these configurations.

---

## 7. Validate Platform-Specific Code

Review the codebase for any APIs or libraries that were Windows-specific in the original .NET Framework project. Common areas to check include:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows Registry access.
- Windows Communication Foundation (WCF) client or service code.
- Any P/Invoke calls targeting Windows-only native libraries.

Replace or remove any such dependencies with cross-platform alternatives.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.