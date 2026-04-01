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

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally and navigate through its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- Application startup with no unhandled exceptions
- Database connectivity from `Bookstore.Data` (verify connection strings in `appsettings.json` are correct for the target environment)
- Domain logic in `Bookstore.Domain` behaves as expected through the UI or API endpoints
- Any file system paths, configuration keys, or environment-specific settings that may have been hardcoded for Windows

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) to confirm:

- Connection strings are valid and point to the correct database
- Any paths use cross-platform separators or `Path.Combine` in code
- Authentication or session configuration is intact

### 6. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or libraries that may not have been caught during transformation:

```bash
grep -rn "System.Web" app/
grep -rn "Registry" app/
grep -rn "Windows" app/
```

Address any findings by replacing them with cross-platform equivalents from the .NET BCL or appropriate NuGet packages.

### 7. Database Migrations

If the project uses Entity Framework Core, verify that migrations are up to date and can be applied against the target database:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```