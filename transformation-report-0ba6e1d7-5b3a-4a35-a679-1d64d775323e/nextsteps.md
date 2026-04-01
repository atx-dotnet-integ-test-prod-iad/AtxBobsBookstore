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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors, particularly around nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output carefully. Any failing tests after migration may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Data Layer Behavior

Since `Bookstore.Data` handles data access, confirm the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider appropriate for your environment).
- Connection strings in configuration files (`appsettings.json`) are valid and accessible from your target environment.
- Run any existing database migrations or verify the schema is compatible:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, including any pages that interact with the data and domain layers. Check the console output and application logs for runtime exceptions that would not surface at compile time.

### 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm the following:

- All configuration has been migrated to `appsettings.json` or environment variables.
- Any `Web.config` or `App.config` transforms that were present in the legacy project have been accounted for.
- Authentication, authorization, and middleware configurations are correctly set up in `Program.cs` or `Startup.cs`.

### 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but may behave differently or require additional packages in cross-platform .NET:

- `System.Web` references should have been fully removed or replaced.
- Any use of the Windows registry, COM interop, or Windows-specific APIs should be identified and handled appropriately if cross-platform deployment is intended.
- Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to surface any remaining compatibility concerns.

### 8. Review Target Framework

Confirm that all projects are targeting the intended framework version in their `.csproj` files:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` to avoid cross-targeting issues.