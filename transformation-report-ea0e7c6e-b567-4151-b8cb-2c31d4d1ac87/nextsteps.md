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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Compatibility

Check each project for any APIs that may have been available in .NET Framework but are not fully supported in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Confirm that the data access layer (e.g., Entity Framework) is using a compatible version. If Entity Framework 6 was used previously, consider whether a migration to Entity Framework Core is necessary or already completed.
- **`Bookstore.Web`**: Confirm that any previously used `System.Web` dependencies have been replaced with their ASP.NET Core equivalents. Features such as `HttpContext`, authentication, session management, and routing should be verified.
- **`Bookstore.Domain`**: Confirm that domain models and business logic do not rely on any platform-specific types.

---

## 4. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing behavior is preserved:

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to behavioral differences between .NET Framework and cross-platform .NET, or due to test configuration issues.

If no tests currently exist, consider writing integration or unit tests for critical paths such as data retrieval and web request handling before proceeding further.

---

## 5. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, run the following to verify that migrations are up to date and the database schema is consistent:

```bash
dotnet ef migrations list
dotnet ef database update
```

Confirm that the connection string in your configuration file (`appsettings.json`) is correct for the target environment.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Verify the following at a minimum:

- The application starts without runtime exceptions.
- Core pages and routes load correctly.
- Data is read from and written to the database as expected.
- Authentication and authorization behave as intended, if applicable.

---

## 7. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Production.json` if applicable) contains all necessary configuration values that were previously held in `Web.config` or `App.config`. Common items to check include:

- Connection strings
- Logging configuration
- Application-specific settings

---

## 8. Publish the Application

Once local validation is complete, publish the application for deployment:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, then deploy to the target environment.