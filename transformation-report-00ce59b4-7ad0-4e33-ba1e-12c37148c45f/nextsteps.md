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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid interoperability issues.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, the project may still reference APIs or packages that are Windows-only. Run the .NET compatibility analyzer to surface any such issues.

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Pay attention to platform compatibility warnings prefixed with `CA1416`. Common problem areas include:
- `System.Drawing` (GDI+)
- Registry access
- Windows-specific authentication providers

---

## 5. Verify Entity Framework or Data Layer Configuration

In `Bookstore.Data`, confirm that the database provider and connection string configuration are compatible with cross-platform .NET. If the project previously used `System.Data.SqlClient`, verify it has been replaced with `Microsoft.Data.SqlClient`.

Check that any database migrations are still valid:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be updated:

```bash
dotnet ef migrations add <MigrationName> --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate runtime behavior.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test project exists, consider manually exercising the core domain logic in `Bookstore.Domain` to confirm expected behavior.

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime exceptions.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas manually:
- Application startup and middleware pipeline
- Database connectivity
- Core application routes and pages
- Authentication and authorization flows, if applicable

Review the console output and any log files for runtime warnings or errors.

---

## 8. Validate Configuration Files

Confirm that `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`) contain valid configuration for the target environment. Ensure that any settings previously stored in `Web.config` have been correctly migrated to the `appsettings.json` format.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.