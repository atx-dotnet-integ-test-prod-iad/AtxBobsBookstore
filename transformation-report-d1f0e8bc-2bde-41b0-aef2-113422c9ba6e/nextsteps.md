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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether they indicate a regression introduced during migration or a test that requires updating to reflect the new target framework.

---

## 4. Verify Entity Framework Core Migrations (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm that your migrations are compatible with the current EF Core version:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

If the project was previously using EF 6 and has been migrated to EF Core, existing migrations may need to be recreated. Verify that the database schema can be applied cleanly:

```bash
dotnet ef database update --project app/Bookstore.Data
```

---

## 5. Validate Runtime Behavior (Bookstore.Web)

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Check the following areas at a minimum:

- Application startup with no unhandled exceptions
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Key user-facing pages and API endpoints

Review the application logs during this process for runtime errors that would not surface at build time.

---

## 6. Review Configuration Files

Confirm that `appsettings.json` (and any environment-specific variants such as `appsettings.Production.json`) contain the correct values for the target environment, including:

- Connection strings
- Logging configuration
- Any application-specific settings previously stored in `Web.config` or `App.config`

If the project previously relied on `Web.config` transforms, ensure those values have been correctly moved to the `appsettings.json` configuration system.

---

## 7. Publish the Application

Once the above validation steps pass, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and dependencies are present before deploying to the target environment.