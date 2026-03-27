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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for their recommended replacements.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test results carefully. Any failing tests should be investigated to determine whether the failure is due to a behavioral change introduced during migration or a pre-existing issue.

---

## 4. Verify Runtime Behavior

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, confirm the following areas work as expected:

- **Database connectivity** – Verify that `Bookstore.Data` connects to the database correctly. If Entity Framework is used, confirm that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic** – Exercise the key workflows driven by `Bookstore.Domain` to confirm business logic is intact.
- **Web layer** – Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering are functioning correctly.

---

## 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- `appsettings.json` (and `appsettings.Production.json`) contains all necessary configuration values previously held in `Web.config`, including connection strings and application settings.
- Any environment-specific configuration is correctly structured using the `IConfiguration` system.
- Sensitive values such as connection strings or API keys are stored using environment variables or the .NET Secret Manager rather than being hardcoded in configuration files.

---

## 6. Check for Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but are not supported or behave differently in cross-platform .NET. Common areas to inspect include:

- `System.Web` references – These are not available in cross-platform .NET and should have been replaced during transformation.
- Windows Registry access (`Microsoft.Win32.Registry`).
- Windows-specific file path assumptions (e.g., hardcoded backslashes).
- `AppDomain` usage, which has limited support in modern .NET.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining concerns.

---

## 7. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.