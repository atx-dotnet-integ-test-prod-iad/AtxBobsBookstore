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

Address any warnings that appear, particularly those related to nullable reference types, deprecated APIs, or target framework compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output carefully. Failures may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm that:

- The connection string in your configuration file (e.g., `appsettings.json`) is valid and points to the correct database.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of sync, apply them with:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core functionality, including any pages or endpoints that interact with `Bookstore.Domain` and `Bookstore.Data`.

### 6. Check for Runtime Compatibility Issues

Pay attention to the following areas that commonly surface runtime issues after a cross-platform migration:

- **File path separators**: Ensure no hardcoded backslashes (`\`) are used in file path logic. Use `Path.Combine` instead.
- **Case sensitivity**: Linux file systems are case-sensitive. Verify that file references, view names, and static asset paths use consistent casing.
- **Windows-specific APIs**: If any code references Windows-only libraries (e.g., `Microsoft.Win32`, COM interop), those will fail on non-Windows platforms and will need to be replaced or conditionally compiled.

### 7. Review Configuration

Confirm that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or environment variables, and that the application reads these values correctly at runtime.