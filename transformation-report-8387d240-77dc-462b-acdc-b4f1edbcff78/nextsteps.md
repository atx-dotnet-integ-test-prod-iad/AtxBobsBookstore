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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages are flagged, update them using:

```bash
dotnet add <project> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Review all three projects for any remaining Windows-specific APIs or packages that may not be compatible cross-platform. Common areas to check:

- Use of `System.Web` (not available on .NET Core/5+)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-only NuGet packages

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility issues.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to verify that existing functionality is preserved after migration:

```bash
dotnet test --configuration Release
```

Review test results for any failures that may indicate behavioral differences between .NET Framework and the new target framework.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally to verify it starts and functions correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following:

- The application starts without runtime exceptions
- Database connectivity works as expected (check connection strings in `appsettings.json`)
- Key application routes and pages load correctly
- Any authentication or authorization middleware functions as expected

---

## 7. Review Configuration Files

Ensure that configuration has been correctly migrated from `Web.config` or `App.config` to `appsettings.json`. Key items to verify:

- Database connection strings
- Application settings keys
- Logging configuration
- Any environment-specific settings (use `appsettings.Development.json` and `appsettings.Production.json` as appropriate)

---

## 8. Validate Data Layer

For `Bookstore.Data`, confirm that Entity Framework (or whichever ORM is in use) is functioning correctly:

- Verify migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

- Apply any pending migrations to a test database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.