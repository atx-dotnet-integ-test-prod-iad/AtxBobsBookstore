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

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework), confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any migrations are still valid by running:

```bash
dotnet ef migrations list
```

- If migrations are missing or invalid, consider regenerating them:

```bash
dotnet ef migrations add InitialMigration
dotnet ef database update
```

### 5. Check Runtime Behavior of the Web Project

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

- Navigate through the application in a browser.
- Test key user flows such as browsing, searching, and any data submission forms.
- Check the console output and application logs for runtime exceptions that would not appear at build time.

### 6. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are correctly configured. Legacy projects often stored configuration in `Web.config` or `App.config`, which are not used in the same way on cross-platform .NET.

- Connection strings should be present in `appsettings.json`.
- Any `Web.config` transforms or `App.config` entries should be reviewed and migrated to the appropriate `appsettings.json` structure.

### 7. Check for Platform-Specific API Usage

Run the .NET compatibility analyzer to surface any APIs that may behave differently or are unavailable on non-Windows platforms:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Review any `CA1416` (platform compatibility) warnings, as these indicate code paths that may fail on Linux or macOS.

### 8. Review Logging and Error Handling

Confirm that logging is configured correctly using `Microsoft.Extensions.Logging` or a compatible provider. Legacy projects may have used `log4net`, `NLog`, or `System.Diagnostics.Trace` in ways that require adjustment for the new hosting model.