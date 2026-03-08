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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- Connection strings in configuration files (e.g., `appsettings.json`) are correct and updated from any legacy `web.config` or `app.config` entries.
- If Entity Framework is used, run the following to verify migrations are in a valid state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated, apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project and verify that it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following manually:

- Application startup completes without exceptions.
- Key pages and routes load correctly.
- Any authentication or authorization flows behave as expected.
- Static assets (CSS, JavaScript, images) are served correctly.

### 6. Review Configuration Files

Confirm that any settings previously stored in `web.config` or `app.config` have been properly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

### 7. Check for Runtime Compatibility Issues

Some APIs behave differently or are unavailable in cross-platform .NET compared to .NET Framework. Manually test any areas of the application that rely on:

- Windows-specific APIs (e.g., `System.Drawing`, registry access, COM interop)
- `HttpContext` usage patterns that differ in ASP.NET Core
- Session and caching mechanisms
- Any third-party libraries that may not fully support the new target framework

### 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting a consistent and supported version of .NET.