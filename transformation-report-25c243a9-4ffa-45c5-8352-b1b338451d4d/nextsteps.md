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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, consider replacing them with their .NET-compatible equivalents from NuGet.

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

Inspect each project for any remaining Windows-specific APIs or packages. Common areas to check include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore.*`)
- Windows Registry access
- `System.Drawing` (replace with a cross-platform alternative such as `SkiaSharp` if needed)
- Any P/Invoke calls targeting Windows-only native libraries

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific code.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --logger trx
```

Review the test results for any failures that may indicate behavioral differences introduced by the migration.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally and manually verify core application flows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas in particular:

- Application startup and middleware pipeline
- Database connectivity via `Bookstore.Data`
- Domain logic correctness via `Bookstore.Domain`
- Any authentication or authorization middleware
- Static file serving and routing

---

## 7. Validate Database Migrations

If the project uses Entity Framework Core, verify that migrations are up to date and can be applied cleanly:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations to a test database to confirm they execute without errors:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) are correctly structured and contain the appropriate connection strings and application settings for the target environment.

Ensure that any configuration that was previously stored in `Web.config` or `App.config` has been properly migrated to the `appsettings.json` format.

---

## 9. Publish the Application

Once all validation steps pass, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.