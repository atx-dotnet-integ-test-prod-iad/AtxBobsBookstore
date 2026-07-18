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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or version conflicts.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that the build output reports zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results carefully. Any failing tests that previously passed may indicate a behavioral regression introduced during the transformation.

### 4. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

### 5. Check for Platform-Specific APIs

Search the codebase for any APIs that were available in .NET Framework but have limited or no support in cross-platform .NET. Common areas to check include:

- `System.Web` references
- Windows Registry access
- `AppDomain` usage
- WCF server-side components
- `HttpContext` usage patterns specific to `System.Web`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to assist with this review.

### 6. Run the Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Walk through the primary user-facing workflows to confirm the application behaves as expected. Pay particular attention to:

- Database connectivity (via `Bookstore.Data`)
- Domain logic correctness (via `Bookstore.Domain`)
- Routing, middleware, and request handling in `Bookstore.Web`

### 7. Verify Configuration Files

Confirm that `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) are present and contain the correct configuration values. If the original project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to the appropriate `appsettings.json` structure or environment variables.

### 8. Validate Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, confirm that migrations are up to date and apply cleanly against the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 9. Review Logging and Error Handling

Confirm that logging is configured correctly in `Program.cs` or `Startup.cs` and that unhandled exceptions surface meaningful output during local testing.