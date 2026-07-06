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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support your current target framework (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time errors.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework Consistency

Open each `.csproj` file and confirm that all three projects target the same framework version. Mismatched target frameworks can cause runtime issues even when the build succeeds.

```xml
<TargetFramework>net8.0</TargetFramework>
```

Also verify that `Bookstore.Web` is using the correct SDK:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
```

---

## 4. Verify Entity Framework Core Configuration

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) matches the target framework.
- Any migrations were generated under the new runtime. If not, regenerate them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 5. Check for Removed or Changed APIs

Cross-platform .NET removed several APIs that existed in .NET Framework. Review the code in all three projects for usage of the following common problem areas:

- `System.Web` namespace — this is not available in cross-platform .NET. Any dependencies on it in `Bookstore.Web` should have been replaced with ASP.NET Core equivalents.
- `ConfigurationManager` — replace with `IConfiguration` via dependency injection.
- `HttpContext.Current` — replace with `IHttpContextAccessor`.
- `BinaryFormatter` — removed in .NET 9; use alternatives such as `System.Text.Json` or `System.Xml.Serialization`.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime exceptions.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows (browsing books, data retrieval, etc.) to confirm end-to-end functionality.

Check the console output and any log files for runtime exceptions or warnings.

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to validate that existing behavior has been preserved.

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and cross-platform .NET rather than bugs in the original code.

---

## 8. Validate Static Assets and Configuration Files

For `Bookstore.Web`, confirm the following:

- `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values previously held in `Web.config` or `App.config`.
- Static files (CSS, JavaScript, images) are located under the `wwwroot` folder and are being served correctly.
- Any `Web.config` transforms or custom HTTP handlers have been replaced with ASP.NET Core middleware equivalents.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, including `appsettings.json` and any static assets.