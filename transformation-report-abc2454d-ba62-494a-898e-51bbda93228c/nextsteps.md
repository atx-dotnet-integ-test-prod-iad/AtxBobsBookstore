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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Behavior

### 3.1 Check Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings. These replace the legacy `Web.config` and `App.config` files.

### 3.2 Check Database Connectivity

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- The connection string in `appsettings.json` points to a valid database instance.
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

### 3.3 Run the Application Locally

Start the web application and verify it loads without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and exercise the core functionality of the application.

---

## 4. Run Automated Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed:

```bash
dotnet test
```

Review the test output for any failures. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by a framework migration.

---

## 5. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` compatibility tooling to identify any runtime-level issues that do not surface at compile time:

```bash
dotnet tool install -g dotnet-compatibility
```

Pay specific attention to:

- `System.Web` references, which are not available in cross-platform .NET and should be replaced with ASP.NET Core equivalents.
- Windows-specific APIs (e.g., registry access, `System.Drawing` without the `System.Drawing.Common` package).
- Any use of `BinaryFormatter`, which is disabled by default in .NET 5 and later.

---

## 6. Validate Static Assets and Views

If `Bookstore.Web` uses Razor views or static files, confirm the following:

- Static files (CSS, JavaScript, images) are located under the `wwwroot` folder.
- Razor views render correctly at runtime.
- Any Razor syntax that relied on legacy `System.Web.Mvc` helpers has been updated to ASP.NET Core Tag Helpers or the equivalent.

---

## 7. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` folder and confirm the output runs correctly in the target environment:

```bash
dotnet ./publish/Bookstore.Web.dll
```