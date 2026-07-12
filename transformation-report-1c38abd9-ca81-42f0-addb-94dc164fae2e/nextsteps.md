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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

- `Bookstore.Domain.csproj`
- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific APIs

Run the .NET Compatibility Analyzer or review the code manually for any APIs that are Windows-only, such as:

- `System.Web` references (should have been replaced with `Microsoft.AspNetCore`)
- Registry access
- Windows-specific file path assumptions

Use the following command to check for platform compatibility warnings:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

---

## 5. Run Database Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, add or update them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate functional correctness:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output for any failures that may indicate behavioral differences introduced by the migration.

---

## 7. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the reported local URL (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify core functionality such as:

- Page rendering
- Data retrieval from `Bookstore.Data`
- Domain logic behavior from `Bookstore.Domain`

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains the correct configuration for the target environment, including:

- Connection strings
- Logging settings
- Any environment-specific overrides in `appsettings.Production.json`

Legacy `Web.config` or `App.config` values should have been migrated to `appsettings.json`. Verify none were missed.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.