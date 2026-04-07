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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` for long-term support.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or libraries. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or IIS-specific middleware
- **System.Drawing** (not fully supported cross-platform without additional packages)
- Any P/Invoke calls targeting Windows DLLs

Use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify these issues.

---

## 5. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that the data access configuration is compatible with cross-platform .NET. Specifically:

- If using **Entity Framework Core**, ensure the correct provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- If using **Entity Framework 6 (classic)**, note that EF6 has limited cross-platform support and migration to EF Core is recommended.
- Confirm that connection strings in `appsettings.json` are correct and do not rely on Windows-integrated security if targeting Linux or macOS.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the URL shown in the console output (typically `http://localhost:5000` or `https://localhost:5001`) and exercise the core functionality of the application, including:

- Page rendering
- Database read and write operations
- Any authentication or authorization flows

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to validate that existing behavior has been preserved after the migration.

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and cross-platform .NET rather than bugs introduced during migration.

If no test projects exist, consider adding unit tests for the core domain logic in `Bookstore.Domain` and integration tests for the data layer in `Bookstore.Data`.

---

## 8. Review `appsettings.json` and Configuration

Confirm that all configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Key areas include:

- Connection strings
- Application settings
- Logging configuration
- Any custom configuration sections

---

## 9. Validate Publish Output

Perform a publish to verify the output is complete and self-contained if needed.

```bash
dotnet publish --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, static assets, and configuration files are present.