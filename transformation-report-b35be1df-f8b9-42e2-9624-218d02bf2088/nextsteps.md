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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, locate them in the respective `.csproj` files and replace them with their .NET-compatible equivalents via [NuGet](https://www.nuget.org/).

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

If no test projects currently exist, consider adding tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework), verify the following:

- Confirm the correct EF Core version is referenced in `Bookstore.Data.csproj`.
- If the project previously used **Entity Framework 6**, ensure it has been migrated to **Entity Framework Core**, as EF6 is not fully supported on cross-platform .NET.
- Check that the connection string in `appsettings.json` (or equivalent) is correctly configured for your target database.
- Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate the Web Layer

Start the `Bookstore.Web` application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All routes and pages load as expected.
- Any authentication or authorization mechanisms function correctly.
- Static assets (CSS, JS, images) are served properly.

If the project previously used **ASP.NET Web Forms** or **ASP.NET MVC 5**, confirm that the UI layer has been appropriately migrated to **ASP.NET Core MVC** or **Razor Pages**, as Web Forms is not supported on cross-platform .NET.

---

## 6. Review Configuration

Cross-platform .NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Verify the following:

- Configuration has been moved to `appsettings.json` and `appsettings.{Environment}.json`.
- Any `Web.config` transforms have been replaced with environment-specific `appsettings` files or environment variables.
- Secrets (connection strings, API keys) are managed using the [.NET Secret Manager](https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets) for local development.

---

## 7. Check for Platform-Specific API Usage

Run the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) or review the code manually for any remaining Windows-specific APIs that may cause issues on Linux or macOS:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Common problem areas include:
- `System.Drawing` (use a cross-platform alternative such as **SkiaSharp** or **ImageSharp**)
- Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions

---

## 8. Publish the Application

Once validation is complete, publish the application to your target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target server or hosting environment.