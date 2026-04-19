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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas of the code that could cause runtime issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform version of .NET (e.g., `net6.0`, `net7.0`, or `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid interoperability issues.

---

## 4. Check for Windows-Specific Dependencies

Review `Bookstore.Data` and `Bookstore.Web` for any remaining references to Windows-specific libraries or APIs, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- COM interop

Replace or remove any such dependencies that are not compatible with cross-platform .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that business logic and data access behavior are functioning as expected.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding to deployment.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and verify:

- Pages load without errors
- Database connections are established correctly
- CRUD operations function as expected

---

## 7. Review Configuration Files

Check `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) to confirm:

- Connection strings are valid and point to the correct database
- Any environment-specific settings have been migrated from `Web.config` or `App.config`
- Sensitive values are not hardcoded and are managed via environment variables or a secrets manager

---

## 8. Validate Database Compatibility

If `Bookstore.Data` uses Entity Framework, verify that any pending migrations are applied correctly.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that the database schema matches what the application expects after migration.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory before deploying to the target environment.