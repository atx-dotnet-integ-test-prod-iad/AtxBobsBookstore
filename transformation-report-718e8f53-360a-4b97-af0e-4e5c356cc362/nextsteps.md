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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Verify that `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- If the original project used `Web.config` or `App.config`, confirm that all relevant settings have been migrated to the appropriate `appsettings.json` or `appsettings.{Environment}.json` files.
- Check that any configuration values previously stored in `System.Configuration.ConfigurationManager` have been replaced with the `Microsoft.Extensions.Configuration` equivalents.

---

## 4. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- The connection string in `appsettings.json` points to a valid and accessible database instance.
- Run any pending migrations to bring the database schema up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application URL printed in the console output (typically `http://localhost:5000` or `https://localhost:5001`).
- Exercise the primary workflows of the application (browsing books, user authentication if applicable, data entry, etc.) and confirm they behave as expected.
- Check the console and any log output for unhandled exceptions or warnings.

---

## 6. Execute Existing Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate runtime behavioral differences between .NET Framework and the new cross-platform .NET runtime that were not caught at compile time.

---

## 7. Check for Platform-Specific API Usage

Even without build errors, some APIs that compiled successfully may not behave correctly on non-Windows platforms. Review the codebase for usage of:

- `System.Drawing` (GDI+) — replace with a cross-platform library such as `SkiaSharp` or `ImageSharp` if image processing is required.
- Windows Registry access (`Microsoft.Win32.Registry`).
- Windows-specific file path assumptions (backslashes, drive letters) — use `Path.Combine` and `Path.DirectorySeparatorChar` instead.
- `System.Web` types that may have been shimmed during transformation — ensure they are fully replaced with ASP.NET Core equivalents.

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` compatibility tooling can assist with identifying remaining issues.

---

## 8. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required static assets, configuration files, and binaries are present before deploying to the target environment.