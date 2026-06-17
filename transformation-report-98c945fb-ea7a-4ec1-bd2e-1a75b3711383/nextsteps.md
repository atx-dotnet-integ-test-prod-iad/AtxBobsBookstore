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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations are up to date and compatible with the target database:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of date or were previously generated under the legacy framework, consider creating a new migration to reflect the current model state:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to confirm it runs correctly in the new cross-platform environment:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL indicated in the console output and manually verify that core functionality such as page rendering, data retrieval, and form submissions work as expected.

---

## 6. Review Configuration Files

Check `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` to confirm the following:

- Connection strings are correct for the target environment.
- Any configuration values that were previously stored in `Web.config` have been properly migrated to the new `appsettings.json` format.
- Environment-specific settings are separated appropriately.

---

## 7. Check for Platform-Specific Code

Since this was a legacy project migration, scan the codebase for any remaining Windows-specific APIs or dependencies that may not behave correctly on Linux or macOS:

- Look for usages of `System.Web` namespaces, which are not available in cross-platform .NET.
- Check for registry access, Windows-specific file paths, or COM interop calls.
- Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if a deeper audit is needed.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to a currently supported version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions are approaching or have reached end of support.