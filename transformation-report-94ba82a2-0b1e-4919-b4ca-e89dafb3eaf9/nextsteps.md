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

Review test results carefully. Any failing tests may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and routing
- Database connectivity from `Bookstore.Data` (verify connection strings are correctly configured for the new environment)
- Any file system paths that may have been hardcoded using Windows-style separators (`\`) — these should be updated to use `Path.Combine` or forward slashes for cross-platform compatibility

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files to confirm that:

- Connection strings are valid and point to the correct database instances
- Any paths or environment-specific values have been updated appropriately for the target platform

### 6. Check for Windows-Specific API Usage

Even without build errors, the code may still reference Windows-specific APIs that will fail at runtime on non-Windows platforms. Use the .NET compatibility analyzer to surface these issues:

```bash
dotnet build /p:PlatformTarget=AnyCPU /p:EnableNETAnalyzers=true
```

Pay particular attention to any usage of the Windows Registry, `System.Drawing`, or COM interop within `Bookstore.Domain` or `Bookstore.Data`.

### 7. Validate Database Migrations

If the project uses Entity Framework Core, confirm that migrations are in a valid state:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a test database before deploying to production:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```