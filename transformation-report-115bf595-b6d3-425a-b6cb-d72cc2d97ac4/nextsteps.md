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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate runtime issues that do not surface at compile time.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify that all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific APIs

Search the codebase for any APIs that are Windows-only and may not function correctly on Linux or macOS. Common areas to inspect include:

- Registry access (`Microsoft.Win32.Registry`)
- Windows Identity and authentication (`System.Security.Principal.WindowsIdentity`)
- File path assumptions using backslashes instead of `Path.Combine`
- `System.Drawing` (GDI+), which requires additional native dependencies on non-Windows platforms

Use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist with this review.

---

## 5. Validate the Data Layer

Since `Bookstore.Data` handles data access, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is compatible with the target framework.
- Any existing database migrations are intact and functional. Run the following to verify:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a test database to confirm schema integrity:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary workflows, paying attention to:

- Pages that load data from the database
- Any authentication or authorization flows
- Static file serving and routing behavior

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 8. Review Application Configuration

Inspect `appsettings.json` and confirm that:

- Connection strings are correct for the target environment.
- Any configuration values previously stored in `Web.config` have been migrated to `appsettings.json` or environment variables.
- The `Startup.cs` or `Program.cs` middleware pipeline is correctly configured for the application's requirements.

---

## 9. Validate on Target Operating System

If the goal is cross-platform support, run the application on the intended non-Windows operating system (Linux or macOS) to surface any platform-specific runtime issues that would not appear during Windows development.