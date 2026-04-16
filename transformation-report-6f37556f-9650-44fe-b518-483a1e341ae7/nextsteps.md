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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Review `Bookstore.Data` and `Bookstore.Web` for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- Windows Registry access
- COM interop components
- `Microsoft.Web.Infrastructure`

Replace or remove any such dependencies with cross-platform equivalents.

---

## 5. Database Migration Verification

If `Bookstore.Data` uses Entity Framework, verify that migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the migrations list is returned without errors, apply them to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration tests that cover the primary data access and web request paths before deploying.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following:

- Application starts without exceptions
- Database connectivity is functional
- Core pages and routes load correctly
- Static assets are served properly

---

## 8. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files to confirm:

- Connection strings are correct and use a supported format
- Any legacy `Web.config` or `App.config` values have been migrated to `appsettings.json`
- Environment variables are correctly referenced where applicable

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.