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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no projects are still referencing `net48` or any other .NET Framework moniker.

---

## 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review test results for any failures that may indicate behavioral differences between .NET Framework and the new target framework.

---

## 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, verify the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Any Entity Framework migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Web Application Locally

Start the web application to confirm it runs correctly on the new framework:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as routing, data access, and rendering works as expected.

---

## 7. Review Configuration Files

Check that the following configuration concerns have been addressed:

- `web.config` is no longer used for application configuration. Settings should have been moved to `appsettings.json`.
- Any `system.web` or IIS-specific configuration that existed in the legacy project may not apply and should be reviewed.
- Middleware previously handled by HTTP Modules or HTTP Handlers should now be implemented using ASP.NET Core middleware in `Program.cs` or `Startup.cs`.

---

## 8. Cross-Platform Validation

If the intent is to run on a non-Windows operating system, test the application on the target OS (Linux or macOS) to identify any remaining platform-specific dependencies such as:

- Windows registry access
- Windows-specific file path separators
- COM interop or Windows-only libraries

```bash
dotnet run --project Bookstore.Web
```

Address any runtime exceptions that surface in this environment.