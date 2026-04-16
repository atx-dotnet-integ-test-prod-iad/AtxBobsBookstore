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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

In `Bookstore.Data`, confirm the following:

- The database provider (e.g., SQL Server, SQLite) is compatible with the target .NET version.
- Entity Framework Core migrations (if applicable) are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be applied to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Review Configuration Files

In `Bookstore.Web`, verify the following:

- `appsettings.json` and `appsettings.Development.json` contain the correct connection strings and application settings.
- Any configuration previously stored in `Web.config` has been correctly migrated to `appsettings.json` or the appropriate .NET configuration mechanism.
- Middleware, service registrations, and application startup logic in `Program.cs` or `Startup.cs` are correct and complete.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Authentication and authorization (if applicable) function as expected.

---

## 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or dependencies that may not behave correctly on Linux or macOS if cross-platform support is required. Tools such as the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the Platform Compatibility Analyzer can assist with this.

---

## 8. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.