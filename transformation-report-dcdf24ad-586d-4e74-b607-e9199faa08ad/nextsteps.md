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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for recommended replacements compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET projects handle configuration differently from legacy .NET Framework projects. Verify the following:

- `appsettings.json` is present in `Bookstore.Web` and contains the correct connection strings and application settings.
- Any settings previously stored in `Web.config` or `App.config` have been migrated to `appsettings.json` or environment variables.
- The `Bookstore.Data` project's database connection string is correctly referenced and functional in the new configuration system.

---

## 4. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core version is referenced (not the legacy `EntityFramework` package).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to confirm existing functionality has not regressed.

```bash
dotnet test
```

Review the test results carefully. Any failing tests should be investigated to determine whether they indicate a behavioral regression introduced during the migration.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web
```

Verify the following at runtime:

- The application starts without exceptions.
- Database connectivity is established and data is returned correctly.
- Core application workflows (browsing, searching, and managing books) function as expected.
- Static assets, routing, and middleware behave correctly.

---

## 7. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or dependencies that may not have been caught during the build phase. Common areas to check include:

- Use of `System.Web` namespaces (not available in .NET Core/.NET 5+).
- Windows Registry access.
- COM interop or Windows-only libraries.
- File path separators hardcoded as `\` instead of using `Path.Combine`.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this review if needed.

---

## 8. Publish the Application

Once validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and static assets are present before deploying to the target environment.