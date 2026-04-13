# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check NuGet.org for their .NET-compatible equivalents and update the `.csproj` files accordingly.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- **Database provider**: Ensure the configured database provider (e.g., SQL Server, SQLite) is compatible with the target .NET version. Check that the correct EF Core or ADO.NET NuGet packages are referenced.
- **Connection strings**: Verify that connection strings in `appsettings.json` or `appsettings.Development.json` are correct and accessible from the new runtime environment.
- **Migrations**: If Entity Framework Core is used, confirm existing migrations are intact and apply them against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All routes and pages load as expected.
- Any authentication or authorization mechanisms function correctly.
- Static assets (CSS, JavaScript, images) are served properly.

Review the console output and application logs for any runtime errors or warnings.

---

## 6. Review Configuration and Environment Settings

Cross-platform .NET handles configuration differently than .NET Framework in some cases. Verify the following in `Bookstore.Web`:

- `appsettings.json` contains all necessary keys previously held in `Web.config` or `App.config`.
- Environment-specific settings (e.g., `appsettings.Development.json`) are correctly structured.
- Any previously used `ConfigurationManager` calls have been replaced with the `IConfiguration` interface.

---

## 7. Check for Platform-Specific API Usage

Run the .NET Compatibility Analyzer or review the code manually for any remaining Windows-specific APIs that may cause issues on non-Windows platforms:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Pay particular attention to file path handling, registry access, and any use of `System.Windows` or `Microsoft.Win32` namespaces.

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, assemblies, and assets are present before deploying to the target environment.