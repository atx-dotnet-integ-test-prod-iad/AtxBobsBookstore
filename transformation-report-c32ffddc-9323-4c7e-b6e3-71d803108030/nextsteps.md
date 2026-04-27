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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Project Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining Windows-specific APIs or packages that may not be compatible on Linux or macOS. Common areas to check include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore` equivalents)
- Windows Registry access
- COM interop
- `System.Drawing` (replace with a cross-platform alternative such as `SkiaSharp` if needed)

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific code paths.

---

## 5. Run Unit Tests

If the solution contains test projects, execute the test suite to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --logger trx
```

Review the test results for any failures that may indicate behavioral differences between .NET Framework and modern .NET.

---

## 6. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the Entity Framework (or whichever ORM is in use) has been updated to its .NET-compatible version.
- If using Entity Framework 6, consider migrating to Entity Framework Core, as EF6 has limited cross-platform support.
- Run any pending database migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify that the application runs correctly:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and test core functionality such as browsing, searching, and any data-driven pages.
- Check the application logs for runtime exceptions or warnings.
- Verify that connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 8. Review Configuration Files

Ensure that configuration has been fully migrated from `Web.config` or `App.config` to `appsettings.json` and the ASP.NET Core configuration system. Key areas to check:

- Database connection strings
- Application settings (e.g., API keys, feature flags)
- Logging configuration
- Authentication and authorization settings

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files are present, then deploy the contents to your target hosting environment.