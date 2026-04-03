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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still referenced, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Data Layer (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for database access, verify the following:

- **Connection strings** in `appsettings.json` (or `appsettings.Development.json`) are correctly configured for the target database.
- If Entity Framework is used, confirm the migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Validate the Domain Layer (Bookstore.Domain)

- Review all domain models and business logic classes to confirm they compile and behave as expected under .NET.
- Check for any use of types or namespaces that were specific to .NET Framework (e.g., `System.Web`, `System.Runtime.Remoting`) and confirm they have been replaced or removed.

---

## 5. Run Unit Tests

If the solution contains a test project, run all tests to verify existing functionality is preserved:

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET that require code adjustments.

If no test project exists, consider writing basic tests that cover:
- Domain model validation
- Data access operations (using an in-memory database if appropriate)
- Key web endpoints or service methods

---

## 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and test key user flows (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console output and application logs for runtime exceptions or warnings.
- Verify that static files, routing, and middleware are functioning correctly.

---

## 7. Review Configuration

- Confirm that `appsettings.json` contains all necessary configuration values previously held in `Web.config` or `App.config`.
- Verify that environment-specific settings (e.g., `appsettings.Development.json`) are in place.
- Ensure any authentication, authorization, or session configuration has been correctly migrated to the ASP.NET Core middleware pipeline in `Program.cs` or `Startup.cs`.

---

## 8. Check for Platform-Specific API Usage

Run the .NET Compatibility Analyzer to identify any remaining platform-specific API calls that may cause issues at runtime:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Address any diagnostics flagged by the analyzer, particularly those marked as errors or critical warnings.

---

## 9. Publish the Application

Once all validation steps pass, publish the application for deployment:

```bash
dotnet publish --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.