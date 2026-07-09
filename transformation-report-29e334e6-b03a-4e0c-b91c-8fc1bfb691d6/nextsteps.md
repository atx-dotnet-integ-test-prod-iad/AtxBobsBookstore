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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Failures in tests that previously passed on the legacy framework may indicate behavioral differences between the old and new runtimes. Pay particular attention to:

- Entity Framework query behavior changes
- Serialization and deserialization differences
- Any middleware or HTTP pipeline behavior in `Bookstore.Web`

---

## 4. Verify the Data Layer (`Bookstore.Data`)

- Confirm that the Entity Framework provider being used is compatible with the target .NET version (e.g., `Microsoft.EntityFrameworkCore` instead of `System.Data.Entity`).
- If database migrations are used, verify existing migrations are intact and run:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Test all database read and write operations against a development database to confirm queries execute as expected.

---

## 5. Verify the Domain Layer (`Bookstore.Domain`)

- Review any domain logic that may have relied on .NET Framework-specific behavior, such as `AppDomain`, `ConfigurationManager`, or specific globalization defaults.
- Confirm that all models and business rules behave correctly by running relevant unit tests or manual verification.

---

## 6. Verify the Web Layer (`Bookstore.Web`)

- Confirm that the application starts without errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate through the application in a browser and verify that all pages render correctly and that form submissions, data retrieval, and navigation function as expected.
- Check that configuration values (e.g., connection strings, app settings) are correctly read from `appsettings.json` rather than `Web.config` or `App.config`, as these are not used in the same way on modern .NET.
- Verify that authentication and authorization middleware, if present, is functioning correctly.

---

## 7. Review Logging and Error Handling

- Confirm that the logging configuration in `appsettings.json` is appropriate for your environment.
- Run the application and intentionally trigger edge cases to confirm that errors are handled and logged correctly.

---

## 8. Validate Runtime Behavior Against the Legacy Application

Where possible, compare the output and behavior of the migrated application side by side with the legacy application to identify any unintended regressions in functionality.

---

## 9. Deploy to a Staging Environment

Once local validation is complete:

1. Publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

2. Deploy the contents of the `./publish` directory to your staging server or hosting environment.
3. Run the same validation steps outlined above against the staging environment before promoting to production.