# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below focus on validating and testing the migrated solution before deploying it.

---

## 1. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 2. Restore Dependencies

Run a NuGet restore to confirm all packages resolve correctly against the new target framework.

```bash
dotnet restore
```

Review the output for any warnings about packages that do not support the target framework or that have been deprecated.

---

## 3. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that were not surfaced during the initial transformation analysis.

```bash
dotnet build --configuration Release
```

Address any warnings related to nullable reference types, obsolete APIs, or platform compatibility that may appear at this stage.

---

## 4. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing behavior has been preserved.

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic unit tests for the domain logic in `Bookstore.Domain` and integration tests for the data access layer in `Bookstore.Data` before proceeding.

---

## 5. Validate Data Access Layer

Since `Bookstore.Data` handles persistence, verify the following:

- If Entity Framework is used, confirm the version has been updated to a version compatible with modern .NET (e.g., `Microsoft.EntityFrameworkCore` 8.x).
- Run any pending migrations or verify the schema is consistent with the updated model.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If a different ORM or ADO.NET is used, test database connectivity manually against your target database.

---

## 6. Check for Windows-Specific APIs

Search the codebase for APIs that are not supported on Linux or macOS if cross-platform deployment is intended. Common areas to check include:

- `System.Web` references (should have been replaced during transformation)
- Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions (backslashes, drive letters)

Use the .NET Compatibility Analyzer to assist with this:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality through the browser.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at a minimum:

- Application starts without runtime exceptions.
- Database queries return expected data.
- All major routes and pages load correctly.
- Any authentication or session handling works as expected.

Review the console output and application logs for runtime warnings or errors.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Production.json` if applicable) contains the correct configuration values, including:

- Connection strings
- Logging settings
- Any application-specific configuration previously held in `Web.config` or `App.config`

Ensure sensitive values are not committed to source control and are instead managed through environment variables or a secrets manager.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify all required assets, views, and static files are present.