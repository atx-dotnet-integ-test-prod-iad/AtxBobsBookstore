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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not cause build failures.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the transformation:

```bash
dotnet test --configuration Release
```

Review test results for any failures or unexpected behavior that may have been introduced during migration.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup completes without exceptions
- Database connectivity is functional (if `Bookstore.Data` uses Entity Framework or another ORM, confirm migrations and queries work correctly)
- Key pages and routes in `Bookstore.Web` load and respond as expected
- Domain logic in `Bookstore.Domain` produces correct results through the UI or API endpoints

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently between .NET Framework and modern .NET. Pay particular attention to:

- `System.Web` usages, which are not available in modern .NET and may have been replaced during transformation
- Any configuration system changes from `Web.config` to `appsettings.json`
- Authentication and authorization middleware differences
- Any use of `HttpContext` or related types that may have changed behavior

### 7. Database Migrations (If Applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that any pending migrations are applied correctly against the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that the schema matches expectations after migration.

### 8. Review Application Logs

After running the application, inspect the output logs for any runtime warnings or errors that do not surface at build time but may indicate underlying issues with the migrated code.