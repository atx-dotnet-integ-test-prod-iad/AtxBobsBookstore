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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

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

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework Core), verify the following:

- **Connection strings** in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target database.
- **Migrations** are up to date. Run the following command to check pending migrations:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as browsing, searching, and managing books behaves as expected.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently than legacy .NET Framework projects. Confirm the following:

- `Web.config` transformations have been replaced with `appsettings.json` and environment-specific variants (e.g., `appsettings.Production.json`).
- Any configuration previously read via `System.Configuration.ConfigurationManager` has been updated to use `Microsoft.Extensions.Configuration`.
- Authentication, authorization, and middleware configurations in `Program.cs` or `Startup.cs` are correct.

---

## 7. Check for Platform-Specific Code

Even without build errors, there may be runtime issues caused by Windows-specific APIs that do not behave identically on Linux or macOS. Search the codebase for usages of the following and test them explicitly:

- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if image processing is involved)
- Windows registry access
- Absolute file paths using backslashes
- `System.Web` remnants

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.