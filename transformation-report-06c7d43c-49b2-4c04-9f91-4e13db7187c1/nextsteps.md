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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` (or `appsettings.Development.json`) are correctly configured for the target database.
- If Entity Framework Core is in use, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as browsing, data retrieval, and any form submissions work as expected.

---

## 6. Review Platform-Specific Code

Check for any remaining usage of Windows-specific APIs or libraries that may not behave correctly on Linux or macOS if cross-platform support is a requirement. Common areas to inspect include:

- File path separators (use `Path.Combine` rather than hardcoded backslashes)
- Registry access (`Microsoft.Win32.Registry`)
- Windows Authentication or IIS-specific configuration in `Bookstore.Web`

---

## 7. Review Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects to avoid framework mismatch issues at runtime.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy them to the target hosting environment.