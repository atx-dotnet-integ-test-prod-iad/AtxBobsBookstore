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

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may still use Windows-specific APIs (e.g., the registry, `System.Windows.Forms`, or `System.Drawing` without the cross-platform NuGet package). Use the .NET Compatibility Analyzer to surface any such issues.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any analyzer warnings and replace or conditionally compile Windows-specific code as needed.

---

## 5. Verify Entity Framework or Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct cross-platform provider is referenced. For example, if using SQL Server:

```bash
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Tools
```

Run any pending migrations to confirm the data layer functions correctly against the target database.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains test projects, execute them to validate business logic and data access behavior.

```bash
dotnet test --configuration Release --verbosity normal
```

Address any failing tests before proceeding.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as browsing, searching, and any data operations work as expected.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains the correct connection strings and application settings for the target environment. Legacy `Web.config` or `App.config` values may not have been fully migrated.

- Connection strings should be in `appsettings.json` under `"ConnectionStrings"`.
- Any `<appSettings>` keys from the old config should be moved to the appropriate section in `appsettings.json`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy to the target host environment.