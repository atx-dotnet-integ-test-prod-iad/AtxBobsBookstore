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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether the failure is due to the migration or a pre-existing issue.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target environment.
- If Entity Framework Core is in use, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as page rendering, navigation, and data retrieval works as expected.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` as the primary configuration mechanism. Confirm the following:

- All configuration values previously in `Web.config` have been moved to `appsettings.json`.
- Environment-specific settings are handled via `appsettings.{Environment}.json` or environment variables.
- Any configuration sections referencing Windows-specific providers or legacy ASP.NET modules have been removed or replaced.

---

## 7. Validate Static Files and Middleware

If the project previously relied on IIS-specific features such as HTTP modules or handlers, confirm that equivalent middleware has been registered in `Program.cs` or `Startup.cs`. Common areas to check include:

- Authentication and authorization middleware
- Custom error handling
- Static file serving via `UseStaticFiles()`

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, configuration files, and binaries are present before deploying to the target environment.