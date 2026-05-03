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

Verify that no warnings or errors are reported during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may point to behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations are up to date by running `dotnet ef database update`.
- **Domain logic**: Exercise the core domain workflows through the UI or API endpoints to confirm correct behavior.
- **Static assets and views**: If the web project uses Razor views or static files, verify they render correctly in the browser.

### 5. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Review the following areas for potential runtime issues that would not appear as build errors:

- **`System.Web` dependencies**: Any code that previously relied on `System.Web` may need to be replaced with ASP.NET Core equivalents.
- **Configuration**: Ensure `web.config`-based configuration has been migrated to `appsettings.json` or environment variables where applicable.
- **Authentication and authorization**: Verify that any membership or identity providers have been updated to ASP.NET Core Identity or equivalent.
- **WCF or Remoting**: These are not supported on cross-platform .NET and would require alternative implementations if present.

### 6. Target Framework Confirmation

Open each `.csproj` file and confirm the `<TargetFramework>` element references a supported cross-platform .NET version (for example, `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48` or another .NET Framework moniker, it will need to be updated.

### 7. Database Compatibility

If the application uses a database, confirm the connection string in `appsettings.json` points to the correct database instance and that the database driver being used (for example, `Microsoft.Data.SqlClient`) is compatible with the target platform.