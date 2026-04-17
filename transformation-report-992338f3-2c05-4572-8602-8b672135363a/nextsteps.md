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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Runtime Compatibility Issues

Even when a project builds cleanly, there may be runtime issues caused by APIs that exist in .NET Framework but behave differently or are absent in cross-platform .NET. Pay particular attention to:

- **`System.Web` dependencies** — these are not available in .NET. Any remaining references should be replaced with ASP.NET Core equivalents.
- **Windows-specific APIs** — such as the registry, WCF server-side components, or `System.Drawing` (use `System.Drawing.Common` with awareness of its platform limitations).
- **Entity Framework** — if the project uses EF6, consider migrating to EF Core. Verify that the `Bookstore.Data` project is using a compatible version.
- **Configuration** — `Web.config` and `App.config` should be replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` infrastructure.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

Review any failing tests. Failures may indicate behavioral differences between .NET Framework and cross-platform .NET that were not caught at compile time.

If no test project exists, consider writing basic integration or smoke tests that cover the primary data access paths in `Bookstore.Data` and the main routes in `Bookstore.Web`.

---

## 6. Validate Database Connectivity

For `Bookstore.Data`, verify that the database connection string in `appsettings.json` is correct and that the application can connect to the database at runtime:

1. Confirm the connection string format is compatible with the chosen data access library (e.g., EF Core, Dapper).
2. If using EF Core migrations, run:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

3. Confirm that all migrations apply cleanly and the schema matches expectations.

---

## 7. Run the Application Locally

Start the web application and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Authentication and authorization (if present) function as expected.
- Static assets (CSS, JavaScript, images) are served correctly.

Check the console output and application logs for any runtime exceptions.

---

## 8. Validate on Target Operating Systems

Since the goal of the migration is cross-platform support, test the application on each operating system you intend to support (Windows, Linux, macOS) to surface any platform-specific issues that would not appear on a single OS.

---

## 9. Publish the Application

Once the application has been validated, publish it for deployment:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including `appsettings.json` and any static web assets.