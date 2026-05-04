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

Review the output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review test results and address any failing tests before proceeding.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Production.json` are correctly configured for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of date, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL printed in the console output and manually verify core functionality, such as browsing, searching, and any data-driven pages.

### 6. Review Configuration Files

Check the following configuration concerns that commonly arise during cross-platform migrations:

- Ensure file paths in configuration do not use Windows-specific backslash separators (`\`). Replace with forward slashes (`/`) or use `Path.Combine()` in code.
- Confirm that any environment-specific settings (e.g., SMTP, storage, API keys) are present and correctly set for the target platform.
- Verify that `appsettings.json` and any environment-specific overrides (`appsettings.Development.json`, `appsettings.Production.json`) are included in the project output.

### 7. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended modern .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.

### 8. Review Removed or Changed APIs

Cross-platform .NET migration may have removed or altered certain APIs that were available in .NET Framework. Specifically, review:

- Any usage of `System.Web` namespaces, which are not available in modern .NET.
- `HttpContext` usage outside of controllers or middleware.
- Any Windows-specific libraries (e.g., registry access, COM interop, WCF) that may require replacement.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if you need further guidance on API compatibility.

### 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files, static assets, and configuration files are present before deploying to the target environment.