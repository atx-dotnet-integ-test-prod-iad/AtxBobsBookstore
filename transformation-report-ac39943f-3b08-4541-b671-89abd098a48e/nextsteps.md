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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for .NET-compatible replacements.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `netcoreapp3.x`, `net5.0`, or `net6.0`, update it to a currently supported version.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect each project for any remaining Windows-only dependencies. Common areas to check include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore` equivalents)
- Windows Registry access
- COM interop
- `System.Drawing` (use `System.Drawing.Common` with the appropriate runtime guard or migrate to a cross-platform alternative)

Run the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Run the Application Locally

Start the `Bookstore.Web` project and verify that the application runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and manually verify core functionality such as:

- Page rendering
- Database connectivity (if applicable)
- Any authentication or authorization flows

---

## 6. Validate the Data Layer

If `Bookstore.Data` uses Entity Framework, verify that migrations are up to date and that the database schema is compatible.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

Confirm that the connection string in `appsettings.json` is correctly configured for the target environment.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to confirm that existing behavior has been preserved after migration.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy framework and the new .NET runtime.

---

## 8. Review Configuration Files

Ensure that configuration has been properly migrated from any legacy formats (such as `Web.config` or `App.config`) to the modern `appsettings.json` pattern. Verify the following:

- Connection strings
- Application settings
- Logging configuration
- Environment-specific overrides (`appsettings.Development.json`, `appsettings.Production.json`)

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.