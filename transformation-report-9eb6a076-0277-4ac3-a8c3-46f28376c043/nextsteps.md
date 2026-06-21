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

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that any Entity Framework migrations are up to date. Run `dotnet ef database update` if needed.
- **Domain logic**: Exercise the core domain features through the UI or API endpoints to confirm correct behavior.
- **Static assets and routing**: Verify that pages render correctly and that all routes resolve as expected.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 6. Check for Removed or Changed APIs

Cross-platform .NET does not include certain APIs that were available in .NET Framework. Review the following areas for potential runtime issues even if the build succeeds:

- **`System.Web` dependencies**: These are not available in cross-platform .NET. Confirm they have been fully replaced with ASP.NET Core equivalents.
- **Configuration**: Ensure `Web.config`-based configuration has been replaced with `appsettings.json` and the `IConfiguration` system.
- **Authentication and authorization**: Confirm that any legacy membership or identity providers have been migrated to ASP.NET Core Identity or an equivalent.
- **Entity Framework**: If the project uses Entity Framework 6, consider whether a migration to Entity Framework Core is necessary or already completed.

### 7. Review Application Logs

After running the application, review the console output and any log files for warnings or errors that do not surface at build time but indicate runtime compatibility issues.