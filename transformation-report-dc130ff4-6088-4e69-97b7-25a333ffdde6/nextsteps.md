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

Verify that no warnings or errors appear related to missing or incompatible packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings, particularly around deprecated APIs or target framework compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced by the migration.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- The connection strings in your configuration files (e.g., `appsettings.json`) are correct and accessible from the new runtime environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, apply them with:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core workflows, such as browsing books, managing inventory, or any other primary features, to confirm they function correctly.

### 6. Review Configuration Files

Check that the following have been updated appropriately for cross-platform .NET:

- `appsettings.json` and `appsettings.Development.json` contain valid and environment-appropriate settings.
- Any file paths referenced in configuration use platform-neutral path separators or `Path.Combine` in code.
- Authentication, logging, and middleware configurations are compatible with the target .NET version.

### 7. Check for Runtime Compatibility Issues

Even without build errors, certain APIs behave differently on cross-platform .NET compared to .NET Framework. Specifically, review the following areas:

- **Windows-specific APIs**: If any code uses `System.Drawing`, Windows registry access, or COM interop, those components will not function on non-Windows platforms.
- **Globalization**: .NET on Linux uses ICU libraries by default. If the application relies on specific culture or encoding behavior, test this explicitly.
- **File system casing**: Linux file systems are case-sensitive. Verify that any file path references in code or configuration use consistent casing.

### 8. Review Deprecated or Replaced APIs

Run the .NET upgrade compatibility analyzer to surface any API usage that may be deprecated or replaced in the target framework version:

```bash
dotnet add package Microsoft.DotNet.UpgradeAssistant.Extensions.Default.Analyzers
dotnet build
```

Address any analyzer warnings that appear in the build output.