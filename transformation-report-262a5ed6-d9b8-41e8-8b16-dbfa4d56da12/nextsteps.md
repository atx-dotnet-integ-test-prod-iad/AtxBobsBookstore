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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated as part of the migration.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the build output for any warnings, even if there are no errors. Warnings related to deprecated APIs or nullable reference types may indicate areas that need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following areas at a minimum:

- Application startup without exceptions
- Database connectivity from `Bookstore.Data` (check connection strings in `appsettings.json`)
- Core domain logic in `Bookstore.Domain` functions as expected through the UI or API endpoints
- Any authentication or authorization flows that were present in the original application

### 5. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to ensure:

- Connection strings are valid and point to the correct database instances
- Any file paths that were previously Windows-specific (e.g., using backslashes) have been updated to use cross-platform equivalents
- API keys or other environment-specific values are correctly configured

### 6. Check for Platform-Specific Code

Even without build errors, there may be runtime issues caused by platform-specific code that compiled successfully but behaves differently on non-Windows systems. Review the codebase for:

- Use of `System.Windows` or `Microsoft.Win32` namespaces
- Registry access
- Windows-specific file path separators
- Any P/Invoke calls targeting Windows-only native libraries

### 7. Review Target Framework

Confirm that each `.csproj` file is targeting the intended .NET version:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid compatibility issues between them.

### 8. Database Migrations

If the project uses Entity Framework Core, verify that any existing migrations are compatible with the updated version of EF Core. Run the following to check the current migration state:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations need to be updated or a new migration is required, generate one with:

```bash
dotnet ef migrations add <MigrationName> --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

## Deployment

Once all validation steps above have been completed and the application behaves as expected:

1. Publish the application using the .NET CLI:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

2. Verify the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present.

3. Deploy the contents of the `./publish` directory to your target hosting environment, ensuring the runtime environment has the appropriate .NET version installed.