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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Behavior

### 3.1 Check Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- Ensure that any settings previously stored in `Web.config` or `App.config` have been migrated to the appropriate `appsettings.json` sections.

### 3.2 Database Connectivity

- Verify the connection string in `appsettings.json` points to the correct database instance.
- If the project uses Entity Framework, run the following to apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If no migrations exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Run the Application Locally

Start the web application to verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication if applicable, etc.).
- Check the console output and application logs for any unhandled exceptions or missing middleware registrations.

---

## 5. Execute Existing Tests

If the solution contains a test project, run all tests to validate core functionality:

```bash
dotnet test
```

- Review any failing tests and determine whether failures are due to the migration or pre-existing issues.
- Pay particular attention to tests that cover data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 6. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas manually:

- **`System.Web` dependencies**: These are not available in .NET. Ensure all usages have been replaced with ASP.NET Core equivalents.
- **`HttpContext` access**: Verify that `IHttpContextAccessor` is used where direct static access was previously used.
- **`ConfigurationManager`**: Confirm all usages have been replaced with `IConfiguration`.
- **WCF or Remoting**: These are not supported. If present, they require replacement with alternative communication mechanisms.

---

## 7. Publish the Application

Once the application has been validated locally, publish it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.