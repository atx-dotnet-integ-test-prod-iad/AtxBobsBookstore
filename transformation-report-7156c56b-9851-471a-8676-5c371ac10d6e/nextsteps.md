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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Entity Framework Core (If Applicable)

Since the project includes a `Bookstore.Data` layer, confirm that any database access is functioning correctly:

- Verify that the connection string in `appsettings.json` (or equivalent configuration) is correct for the target environment.
- If the project uses Entity Framework, apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the EF Core provider being used (e.g., SQL Server, SQLite, PostgreSQL) is compatible with the target .NET version.

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser and verify that pages load correctly.
- Check the console output for any runtime exceptions or unhandled errors.
- Review any middleware configuration in `Program.cs` or `Startup.cs` to confirm it is compatible with the current .NET version.

---

## 6. Review Configuration and Environment Settings

- Confirm that `appsettings.json` and `appsettings.Production.json` contain the correct values for the target environment.
- Verify that any environment variables previously set in `Web.config` (if migrating from ASP.NET Framework) have been moved to the appropriate .NET configuration sources.
- Check that authentication, authorization, and session configurations have been correctly migrated.

---

## 7. Publish the Application

Once local validation is complete, publish the application to the target deployment directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files, static assets, and configuration files are present before deploying to the target server or hosting environment.