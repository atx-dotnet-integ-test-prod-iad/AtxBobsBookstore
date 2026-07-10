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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by framework differences.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your database connection string is correctly configured for the target environment. Then check the state of your migrations:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of date or missing, create and apply them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm that:

- `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values previously held in `Web.config`.
- Connection strings, application settings, and any environment-specific values have been correctly migrated.
- Any `configSource` references or `appSettings` file references from the old config have been manually transferred.

---

## 6. Run the Web Application Locally

Start the application locally and navigate through its core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without runtime exceptions.
- Pages and routes load correctly.
- Data is read from and written to the database as expected.
- Authentication and authorization flows work if applicable.

---

## 7. Review Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but behave differently or are unavailable in cross-platform .NET. Common areas to check include:

- `System.Web` references that may have been replaced with ASP.NET Core equivalents.
- Windows-specific APIs such as the registry, WCF, or MSMQ.
- Any use of `HttpContext` that may need to be accessed via `IHttpContextAccessor` in ASP.NET Core.
- `Thread.CurrentPrincipal` usage, which should be replaced with `HttpContext.User`.

---

## 8. Test on Target Operating System

If the goal of the migration is cross-platform support, run and test the application on the intended non-Windows operating system (e.g., Linux or macOS) to surface any remaining platform-specific issues:

```bash
dotnet run --project Bookstore.Web
```

Pay attention to:

- File path separators (`\` vs `/`).
- Case-sensitive file and directory names on Linux.
- Any P/Invoke or native library dependencies that may not be available.