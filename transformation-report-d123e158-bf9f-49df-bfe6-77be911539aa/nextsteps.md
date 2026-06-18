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

## 4. Check for Windows-Specific Dependencies

Even without build errors, some NuGet packages or APIs may only function on Windows. Review the dependencies in each `.csproj` for packages that are Windows-only, such as:

- `Microsoft.Web.Infrastructure`
- `System.Web.*`
- Any package with a `windows` target framework moniker (e.g., `net8.0-windows`)

Replace or remove these where cross-platform support is required.

---

## 5. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify runtime behavior has not regressed.

```bash
dotnet test --configuration Release
```

Review the test results carefully, paying attention to any failures related to data access, configuration loading, or HTTP request handling.

---

## 6. Validate Application Configuration

Legacy .NET Framework projects used `Web.config` and `App.config` for configuration. Cross-platform .NET uses `appsettings.json`. Confirm the following:

- Connection strings previously in `Web.config` have been moved to `appsettings.json` or environment variables.
- Any `<appSettings>` keys have been migrated to the `appsettings.json` structure.
- The `Bookstore.Web` project uses `IConfiguration` to read settings rather than `ConfigurationManager`.

---

## 7. Validate Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If using Entity Framework, verify it has been updated to **Entity Framework Core**.
- Run any pending migrations or verify the schema is compatible with the target database.

```bash
dotnet ef migrations list
dotnet ef database update
```

- If `Database.SetInitializer` or other EF 6-specific APIs are present, they must be replaced with EF Core equivalents.

---

## 8. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and test:

- Page rendering and routing
- Database read and write operations
- Authentication and authorization flows, if applicable

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory before deploying to the target environment.