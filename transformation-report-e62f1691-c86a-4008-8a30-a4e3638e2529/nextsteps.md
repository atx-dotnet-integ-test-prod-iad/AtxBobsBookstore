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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether they indicate a regression introduced during the transformation or a pre-existing issue.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider package (e.g., Entity Framework Core) is the correct version for your target .NET version.
- If the project uses Entity Framework, run the following to verify the model and migrations are consistent:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Ensure connection strings in configuration files (e.g., `appsettings.json`) are correct for your target environment.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review any domain models and business logic classes for use of APIs that may behave differently on cross-platform .NET compared to .NET Framework.
- Pay particular attention to any use of `System.Configuration`, `AppDomain`, or other APIs that had limited or changed support during migration.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Confirm that the `Bookstore.Web` project runs locally:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Open the application in a browser and navigate through the key pages and features to verify expected behavior.
- Check that static files, routing, authentication (if applicable), and any middleware are functioning correctly.
- Review `Program.cs` and any `Startup.cs` to confirm the middleware pipeline is configured appropriately for the new hosting model.

---

## 7. Review Configuration Files

- Ensure `appsettings.json` and `appsettings.{Environment}.json` contain all settings that were previously in `Web.config` or `App.config`.
- Confirm that environment-specific settings (e.g., connection strings, API keys) are correctly separated and not committed to source control.

---

## 8. Cross-Platform Smoke Test

If cross-platform support is a goal, run the application on a non-Windows environment (Linux or macOS) to identify any remaining platform-specific dependencies:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Look for runtime exceptions related to file path separators, Windows-specific APIs, or registry access.

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.