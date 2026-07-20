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

Ensure no project still references `net48` or any other Windows-only framework moniker.

---

## 4. Run the Application Locally

Start the web application to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL printed in the console output and verify that the application loads correctly and core functionality is intact.

---

## 5. Check for Windows-Specific APIs

Search the codebase for any APIs that are not supported on cross-platform .NET. Common areas to review include:

- `System.Web` references (not available in .NET Core or later)
- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `HttpContext.Current` usage

Use the .NET Upgrade Assistant compatibility analyzer or the following command to surface platform compatibility warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 6. Validate Data Layer

If `Bookstore.Data` uses Entity Framework, verify the following:

- Confirm the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`)
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Confirm connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 7. Execute Unit Tests

If the solution contains a test project, run all tests to verify that existing functionality has not regressed:

```bash
dotnet test
```

Review the test results and investigate any failures before proceeding.

---

## 8. Review Configuration Files

Ensure that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Authentication or authorization configuration

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.