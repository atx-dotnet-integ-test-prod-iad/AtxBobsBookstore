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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no project is still referencing `net48` or any other .NET Framework moniker.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that are not available in cross-platform .NET. Common areas to inspect include:

- `System.Web` references, which are not available outside of ASP.NET on .NET Framework
- `HttpContext`, `HttpRequest`, and related types, which have changed in ASP.NET Core
- `ConfigurationManager`, which should be replaced with `Microsoft.Extensions.Configuration`
- Windows-specific APIs such as the registry or certain `System.Drawing` types

---

## 5. Review and Update Configuration

If the project previously used `Web.config` or `App.config`, confirm that configuration has been migrated to `appsettings.json`. Verify the following in `Bookstore.Web`:

- `appsettings.json` exists and contains the necessary connection strings and application settings
- `Program.cs` or `Startup.cs` correctly loads configuration using `IConfiguration`

---

## 6. Database and Data Layer Validation

In `Bookstore.Data`, verify the following:

- If Entity Framework is used, confirm the version is Entity Framework Core and not the older `EntityFramework` (EF6) package
- Run any pending migrations or verify the schema is compatible:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm connection strings in `appsettings.json` are correct for your target database environment

---

## 7. Run Unit Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test
```

If no test project exists, consider manually testing the critical paths in `Bookstore.Domain` and `Bookstore.Data`, such as data retrieval and domain logic.

---

## 8. Run the Application Locally

Start the web application locally and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and test the primary workflows, such as browsing books, user authentication if applicable, and any data submission forms.

---

## 9. Cross-Platform Verification

If cross-platform support is a requirement, run and test the application on a non-Windows operating system (Linux or macOS) to identify any platform-specific runtime issues that would not surface during a Windows build.

---

## 10. Review Warnings and Code Quality

After confirming the application runs correctly, address any remaining compiler warnings. Pay particular attention to:

- Nullable reference type warnings (`CS8600`, `CS8602`, `CS8603`)
- Obsolete API usage warnings
- Any `SYSLIB` diagnostic codes indicating the use of deprecated or replaced APIs