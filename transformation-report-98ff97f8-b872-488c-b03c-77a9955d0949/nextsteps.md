# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns worth addressing.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may point to behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Layer Behavior

Since `Bookstore.Data` is present, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry forms, to confirm end-to-end functionality.

### 6. Review Configuration Files

- Confirm that `appsettings.json` contains the correct connection strings and application settings that were previously in `Web.config` or `App.config`.
- Verify that any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate.

### 7. Check for Runtime-Specific API Usage

Even with a clean build, some APIs behave differently or are absent in cross-platform .NET compared to .NET Framework. Pay particular attention to:

- `System.Web` references, which are not available outside of ASP.NET Core.
- Windows-specific APIs such as the registry, certain cryptography providers, or COM interop.
- Any third-party libraries that may have been targeting .NET Framework and have not yet been updated to a compatible version.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to surface any such issues.

### 8. Review Nullable Reference Type Warnings

If the new project files have nullable reference types enabled (`<Nullable>enable</Nullable>`), review any warnings produced during the build. While these are not errors by default, addressing them improves code correctness and future maintainability.