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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings that could indicate runtime issues.

---

## 3. Review Configuration Files

Check the following configuration-related items that commonly require manual attention after a cross-platform migration:

- **`appsettings.json`**: Confirm that connection strings and other settings previously in `Web.config` or `App.config` have been correctly moved to `appsettings.json`.
- **`Program.cs` / `Startup.cs`**: Verify that middleware, services, and the request pipeline are configured correctly for the new hosting model.
- **Environment-specific settings**: Ensure `appsettings.Development.json` and `appsettings.Production.json` are present and correctly configured if needed.

---

## 4. Database Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- Confirm the EF Core provider package matches your target database (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Check that all migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm core functionality is intact.

---

## 6. Execute Existing Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and the new .NET runtime that require code adjustments.

---

## 7. Cross-Platform Verification

Since the goal of the migration is cross-platform compatibility, verify the application runs correctly on each target operating system (Windows, Linux, macOS) if applicable. Pay particular attention to:

- **File path separators**: Ensure no hardcoded backslashes (`\`) are used in file path logic. Use `Path.Combine` instead.
- **Case sensitivity**: Linux file systems are case-sensitive. Verify that file references, view names, and static asset paths use consistent casing.
- **Windows-specific APIs**: Confirm no remaining dependencies on Windows-only APIs exist (e.g., the Windows Registry, `System.Drawing` GDI+).

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.