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

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any compile-time errors:

```bash
dotnet build --configuration Release
```

Review the build output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failing tests to determine if they are related to the migration or pre-existing issues.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Removed or Changed APIs

Review any usages of APIs that are known to be unavailable or changed in cross-platform .NET, particularly in the following areas:

- `Bookstore.Data`: Verify that the database provider (e.g., Entity Framework Core) is correctly configured and that any connection strings reference a supported database driver.
- `Bookstore.Web`: Confirm that middleware, authentication, and any HTTP modules or handlers from legacy ASP.NET have been correctly replaced with their ASP.NET Core equivalents.
- `Bookstore.Domain`: Check that no Windows-specific types or libraries are referenced.

### 6. Run the Application Locally

Start the application using the .NET CLI:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and manually exercise the core workflows, such as browsing books, managing inventory, and any authentication flows, to confirm runtime behavior is correct.

### 7. Validate Configuration Files

Check `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to ensure:

- Connection strings are valid and point to the correct database.
- Any keys or settings previously stored in `Web.config` have been migrated to the appropriate `appsettings.json` entries.
- The `Web.config` file, if still present, is not being relied upon for runtime configuration.

### 8. Review Logging and Error Handling

Run the application and inspect the console output and any configured log sinks for warnings or errors that may not surface as build errors but indicate runtime issues, such as missing configuration values or failed dependency injections.