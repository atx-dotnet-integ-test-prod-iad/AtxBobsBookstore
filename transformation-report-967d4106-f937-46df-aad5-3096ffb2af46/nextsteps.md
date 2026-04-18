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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. Address any that appear.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

In `Bookstore.Data`, confirm the following:

- The database provider (e.g., Entity Framework Core) is correctly configured for cross-platform use.
- Connection strings in `appsettings.json` or environment variables are valid for the target environment.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

If the project previously used `System.Data` or a provider tied to Windows (e.g., `System.Data.SqlClient`), confirm it has been replaced with the cross-platform equivalent such as `Microsoft.Data.SqlClient`.

---

## 5. Verify Web Application Startup

Navigate to the `Bookstore.Web` project directory and run the application locally.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following:

- The application starts without runtime exceptions.
- All routes resolve correctly.
- Static assets load as expected.
- Any authentication or session middleware is functioning correctly.

---

## 6. Review Configuration Files

Confirm that the following have been updated appropriately for cross-platform .NET:

- `appsettings.json` and `appsettings.Development.json` contain valid and environment-appropriate settings.
- Any file paths in configuration use platform-agnostic path separators or `Path.Combine`.
- Logging configuration is in place and functional.

---

## 7. Check for Windows-Specific API Usage

Search the codebase for any remaining usage of Windows-specific APIs that may not have been caught during transformation. Common examples include:

- `Microsoft.Win32` namespace references
- `RegistryKey` usage
- Windows-specific file path assumptions (e.g., hardcoded `C:\` paths)
- `System.Drawing` (GDI+), which has limited cross-platform support and should be replaced with an alternative such as `SkiaSharp` if used

---

## 8. Publish the Application

Once validation is complete, publish the application for the target runtime.

For a self-contained deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --runtime linux-x64 \
  --self-contained true \
  --output ./publish
```

For a framework-dependent deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.