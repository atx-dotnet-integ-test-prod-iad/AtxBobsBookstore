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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review test output carefully. Any failing tests may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

---

## 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, verify that the data layer is functioning correctly:

- Confirm the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- If the project uses migrations, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the displayed local URL in a browser.
- Exercise the primary application flows (e.g., browsing books, data retrieval) to confirm end-to-end functionality.
- Check the console output and application logs for any runtime exceptions or warnings.

---

## 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Verify the following:

- Connection strings are correctly defined in `appsettings.json` or `appsettings.Development.json`.
- Any environment-specific configuration is properly separated using the `appsettings.{Environment}.json` pattern.
- Sensitive values such as connection strings or API keys are not hardcoded and are managed via environment variables or the .NET Secret Manager for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your_connection_string"
```

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but are absent or behave differently in cross-platform .NET. Common areas to inspect include:

- `System.Web` namespace usage (should have been removed or replaced during transformation).
- Windows Registry access or Windows-specific I/O paths.
- `HttpContext` or `Session` usage, which may require explicit middleware configuration in ASP.NET Core.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to surface any remaining compatibility issues:

```bash
upgrade-assistant analyze Bookstore.sln
```

---

## 8. Validate Target Framework

Confirm each project is targeting the intended .NET version by inspecting the `.csproj` files. The `TargetFramework` property should reflect a current supported version such as `net8.0`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Refer to the [.NET support lifecycle](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to ensure the chosen version is within its support window.