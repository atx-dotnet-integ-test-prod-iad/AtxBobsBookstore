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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages are flagged, consider updating them to versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review the dependencies in each project for any packages or APIs that are Windows-only. Pay particular attention to:

- Any use of `System.Web` (not available in cross-platform .NET)
- Windows Registry access
- COM interop
- `Microsoft.Web.*` packages that may have been part of the legacy ASP.NET stack

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling if needed.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that business logic and data access behavior is preserved:

```bash
dotnet test --configuration Release
```

Review test results carefully. Failures may indicate behavioral differences between the legacy .NET Framework and the new .NET runtime.

---

## 6. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to a compatible version (e.g., EF Core).
- If the project previously used `System.Data.Entity` (EF 6 for .NET Framework), verify it has been migrated to `Microsoft.EntityFrameworkCore`.
- Run any existing database migrations or verify the schema is still compatible:

```bash
dotnet ef database update
```

---

## 7. Validate the Web Layer (`Bookstore.Web`)

- If the project was previously ASP.NET MVC (System.Web-based), confirm it has been migrated to ASP.NET Core.
- Start the application locally and navigate through key pages to verify routing, views, and data rendering work as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Check that middleware configuration in `Program.cs` or `Startup.cs` is correct, including authentication, static files, and routing.

---

## 8. Review Configuration Files

- Ensure `appsettings.json` contains the necessary configuration that was previously in `Web.config` or `App.config`.
- Verify connection strings, logging settings, and any environment-specific configuration are correctly defined.
- Confirm that `Web.config` is no longer being relied upon for runtime configuration (it is not used by ASP.NET Core).

---

## 9. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, consider running the application on Linux or macOS to surface any remaining platform-specific issues:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 10. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.