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

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may indicate behavioral differences between the legacy .NET Framework version and the new cross-platform .NET version.

---

## 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, verify the data layer is functioning correctly:

- Confirm the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target .NET version.
- If the project uses Entity Framework migrations, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be applied to a local development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and verify that core pages and features load correctly.
- Check the console output for any runtime exceptions or middleware configuration errors.
- Confirm that connection strings in `appsettings.json` are correctly configured for your local environment, as the legacy `Web.config` connection strings would have been migrated to this file.

---

## 6. Review Configuration Migration

Legacy .NET Framework projects use `Web.config` for configuration. Cross-platform .NET uses `appsettings.json`. Verify the following:

- All connection strings are present in `appsettings.json`.
- Any `appSettings` key-value pairs from `Web.config` have been moved to `appsettings.json`.
- Environment-specific configuration is handled using `appsettings.Development.json` or environment variables where appropriate.

---

## 7. Check for Windows-Specific Dependencies

Cross-platform .NET may surface runtime issues on non-Windows environments if the original project relied on Windows-specific APIs. Review the `Bookstore.Data` and `Bookstore.Domain` projects for any usage of:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows Registry access
- COM interop components
- Windows-only authentication mechanisms (e.g., NTLM/Windows Authentication requires additional configuration)

If any such dependencies are found, they will need to be replaced with cross-platform equivalents.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.