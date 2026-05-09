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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

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

If any project still targets `net48` or `netstandard2.0`, evaluate whether it needs to be updated to a current .NET target.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for any APIs or libraries that are Windows-only, such as:

- `System.Web`
- `Microsoft.Win32`
- Windows Registry access
- COM interop

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify these.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and modern .NET.

---

## 6. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework), verify the following:

- The correct version of Entity Framework Core is referenced (not the legacy `EntityFramework` package).
- Any database migrations are present and up to date.
- Run a migration check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a local development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at a minimum:

- The application starts without runtime exceptions.
- Database connectivity is functional.
- Core pages and routes load as expected.
- Any authentication or session handling works correctly.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Development.json`) contain all necessary configuration values that may have previously existed in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Logging configuration
- Application-specific settings

The legacy `Web.config` transformation system is not used in modern .NET. Configuration is now handled through `appsettings.json` and environment variables.

---

## 9. Validate on a Non-Windows Platform (Optional)

If cross-platform support is a goal, run the application on Linux or macOS to confirm there are no remaining platform-specific dependencies.

```bash
dotnet run --project Bookstore.Web
```

Address any `PlatformNotSupportedException` or similar runtime errors that surface during this step.