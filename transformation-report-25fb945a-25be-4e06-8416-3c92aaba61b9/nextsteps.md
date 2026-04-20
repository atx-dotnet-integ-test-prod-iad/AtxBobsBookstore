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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mismatched target frameworks between `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` can cause runtime issues even when the build succeeds.

---

## 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm that any Entity Framework or data access configuration has been updated appropriately:

- If using **Entity Framework Core**, ensure the correct EF Core NuGet packages are referenced and that any `DbContext` configuration uses the EF Core API rather than the legacy EF 6 API.
- Run any pending migrations or verify the database schema is compatible:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Check Configuration Files

Legacy .NET Framework projects use `Web.config` and `App.config`. Cross-platform .NET uses `appsettings.json`. Verify the following:

- `appsettings.json` exists in `Bookstore.Web` and contains the necessary connection strings and application settings.
- Any environment-specific overrides are handled via `appsettings.{Environment}.json` or environment variables.
- No remaining references to `ConfigurationManager` exist unless the `System.Configuration.ConfigurationManager` NuGet package has been explicitly added.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

---

## 7. Execute Existing Tests

If the solution contains test projects, run them to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 8. Inspect Runtime Behavior for Platform-Specific APIs

Some APIs available in .NET Framework are not available or behave differently in cross-platform .NET. Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining platform-specific calls, particularly in `Bookstore.Web` and `Bookstore.Data`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.