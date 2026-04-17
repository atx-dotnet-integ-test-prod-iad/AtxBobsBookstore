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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the target framework you are using (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly:
- **Nullable reference type warnings** — these may indicate areas where null safety has changed between the old and new framework.
- **Obsolete API warnings** — some APIs available in .NET Framework may have been marked obsolete or removed in cross-platform .NET.

---

## 3. Verify the Data Layer (`Bookstore.Data`)

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework), confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Sqlite`, etc.).
- Any existing migrations are still valid by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated, apply migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that connection strings in `appsettings.json` are correctly configured for your target environment.

---

## 4. Verify the Domain Layer (`Bookstore.Domain`)

- Confirm that all domain models, interfaces, and business logic compile and behave as expected.
- If any types previously relied on `System.Web` or other .NET Framework-specific namespaces, verify those have been replaced with appropriate cross-platform equivalents.

---

## 5. Verify the Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` and/or `Startup.cs` are structured correctly for the target .NET version.
- If the project was migrated from ASP.NET (System.Web) to ASP.NET Core, verify:
  - Middleware configuration (`app.UseRouting()`, `app.UseAuthentication()`, etc.)
  - Dependency injection registrations in `builder.Services` or `ConfigureServices`
  - Any `Web.config` settings have been moved to `appsettings.json` or middleware configuration
- Run the web application locally:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and verify that core pages and functionality load without errors.
- Check the console output and application logs for any runtime exceptions.

---

## 6. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing behavior has been preserved:

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and cross-platform .NET rather than bugs in the original code.

---

## 7. Manual Functional Validation

Perform a manual walkthrough of the core application features, including:

- Browsing and searching for books
- Any authentication or authorization flows
- Data entry and persistence (create, update, delete operations)
- Any file upload or download functionality, if present

---

## 8. Review Configuration and Environment Settings

- Ensure `appsettings.json` and `appsettings.{Environment}.json` contain all settings previously held in `Web.config` or `App.config`.
- Confirm that environment-specific settings (e.g., connection strings, API keys) are correctly separated and not hardcoded.
- Validate that the application reads the correct configuration when run under different environments (e.g., `Development`, `Production`).

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, then deploy the output to your target hosting environment.