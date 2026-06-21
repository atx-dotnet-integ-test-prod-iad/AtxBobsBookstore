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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that are compatible with the current .NET target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) in `Bookstore.Web` to confirm the following:

- Connection strings are valid and point to the correct database instances.
- Any configuration keys that were previously stored in `Web.config` have been correctly migrated to the `appsettings.json` format.
- Authentication, logging, and middleware settings are correctly defined.

---

## 4. Verify Entity Framework Migrations

If `Bookstore.Data` uses Entity Framework, verify that existing migrations are compatible with the current version of EF Core being used.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be updated, apply the migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the database schema matches expectations after the update.

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute all tests to validate that the business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave correctly.

```bash
dotnet test
```

Review test results and address any failures. Pay particular attention to tests that cover data access layers, as EF Core behavior can differ from EF6 in certain scenarios such as lazy loading, cascade deletes, and query translation.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web
```

Verify the following:

- The application starts without runtime exceptions.
- All pages and routes load correctly.
- Database read and write operations function as expected.
- Authentication and authorization flows work correctly if applicable.

---

## 7. Check for Platform-Specific Code

Search the codebase for any remaining usage of Windows-specific APIs or libraries that may not be compatible with cross-platform .NET. Common areas to check include:

- Registry access (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side usage
- `System.Drawing` (GDI+) without the `System.Drawing.Common` NuGet package
- Any P/Invoke calls targeting Windows-only system libraries

Address any findings by replacing them with cross-platform alternatives.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.