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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-only APIs are being used unintentionally. Run the compatibility analyzer by adding the following to each `.csproj` if not already present:

```xml
<EnableNETAnalyzers>true</EnableNETAnalyzers>
<AnalysisMode>All</AnalysisMode>
```

Rebuild and review any `CA1416` platform compatibility warnings, which indicate calls to Windows-specific APIs that would fail on Linux or macOS.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) has been updated to a compatible version.
- Run any pending migrations or verify the database schema is correct:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If `dotnet-ef` is not installed globally, install it with:

```bash
dotnet tool install --global dotnet-ef
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, managing inventory, or any other core features, to confirm end-to-end functionality.

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to validate that existing behavior has been preserved after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests. Failures may indicate behavioral differences between .NET Framework and modern .NET that require code adjustments.

---

## 8. Review `appsettings.json` and Configuration

Legacy projects often used `Web.config` or `App.config` for configuration. Confirm that all necessary settings, such as connection strings and application settings, have been moved to `appsettings.json` and are being read correctly via `IConfiguration`.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

Ensure sensitive values are not committed to source control and are instead managed via environment variables or a secrets manager.

---

## 9. Publish the Application

Once the application has been validated locally, publish it to a self-contained or framework-dependent deployment artifact.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.