# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or version conflicts. Address any packages that may have been marked as deprecated or that target only .NET Framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Review the build output for any warnings that may indicate behavioral differences between .NET Framework and modern .NET, such as:

- Obsolete API usage
- Platform compatibility warnings (`CA1416`)
- Nullable reference type warnings if nullable context is enabled

---

## 3. Review Configuration Files

Modern .NET uses `appsettings.json` instead of `Web.config` or `App.config` for most configuration. Verify the following:

- Connection strings have been moved to `appsettings.json` in `Bookstore.Web`
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`
- Any remaining `.config` files are intentional and still required

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that:

- The correct version of Entity Framework (EF Core is standard for modern .NET) is being used
- Database migrations are present and up to date
- The `DbContext` is registered correctly in the dependency injection container in `Bookstore.Web`

If EF Core is in use, run the following to verify migrations are in a valid state:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web --configuration Development
```

Check the following at runtime:

- The application starts without exceptions
- Database connectivity is functional
- Key pages and routes load correctly
- Any authentication or authorization middleware functions as expected

---

## 6. Run Existing Tests

If a test project exists in the solution, execute the test suite to verify that existing functionality has not regressed.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to the migration or pre-existing issues.

---

## 7. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not available or behave differently in modern .NET. Review the following areas manually:

- `HttpContext` usage in `Bookstore.Web`
- Any use of `System.Web` namespaces, which are not available in modern .NET
- Synchronous I/O patterns that may need to be updated to async equivalents
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET

---

## 8. Publish the Application

Once the application has been validated locally, publish it for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.