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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for .NET-compatible replacements.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same or compatible framework versions to avoid runtime compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect the code and package references for any APIs or libraries that are Windows-only. Common areas to check include:

- `System.Web` references (not available in .NET Core/5+)
- Windows Registry access
- COM interop
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

If any such dependencies exist, they will need to be replaced with cross-platform equivalents.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) is properly configured.
- Verify the database connection string in `appsettings.json` is correct for your target environment.
- If using EF Core, run the following to verify migrations are in a valid state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of date, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, run all tests to verify that existing functionality behaves as expected after migration.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy .NET Framework and the new .NET runtime.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web
```

Navigate through the application and verify:

- Pages load without errors
- Database reads and writes function correctly
- Authentication and authorization behave as expected (if applicable)
- Any file I/O or path-dependent logic works correctly on the target OS

---

## 8. Review `appsettings.json` and Configuration

Legacy projects often used `Web.config` or `App.config` for configuration. Confirm that all necessary configuration values have been migrated to `appsettings.json` and that the application reads them using the `IConfiguration` interface.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.