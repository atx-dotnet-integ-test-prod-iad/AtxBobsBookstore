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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly and that all queries return expected results. Pay particular attention to any Entity Framework migrations or database initialization logic that may behave differently on the new runtime.
- **Domain logic**: Exercise the core business logic surfaced by `Bookstore.Domain` to ensure calculations, validations, and rules produce the same results as the legacy application.
- **Web layer**: Navigate through the application pages or API endpoints exposed by `Bookstore.Web` and verify that routing, model binding, authentication, and rendering all function correctly.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` for runtime configuration. Confirm that:

- All connection strings and application settings have been moved to `appsettings.json` or environment variables.
- Any `Web.config` transforms or `configSource` references have been replaced with the appropriate .NET configuration providers.
- The `ASPNETCORE_ENVIRONMENT` environment variable is set correctly for your target environment (e.g., `Development`, `Production`).

### 6. Check for Windows-Specific Dependencies

Even when a build succeeds, runtime failures can occur if the code relies on Windows-specific APIs. Review the following:

- Any use of the Windows registry, COM interop, or Windows Authentication should be tested explicitly.
- File path separators should use `Path.Combine` or `Path.DirectorySeparatorChar` rather than hardcoded backslashes.
- If the application is intended to run on Linux or macOS, test it on those platforms directly.

### 7. Review Deprecated or Replaced APIs

Some APIs available in .NET Framework are absent or behave differently in cross-platform .NET. Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` compatibility shims if any runtime exceptions surface related to missing members.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

This will surface compatibility warnings at build time for any remaining problem areas.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required assemblies, static assets, and configuration files are present before deploying to the target environment.