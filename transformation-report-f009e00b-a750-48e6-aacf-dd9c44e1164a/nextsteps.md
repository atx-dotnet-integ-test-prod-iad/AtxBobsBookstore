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

Verify that no warnings or errors are reported during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any database connection strings in your configuration files (e.g., `appsettings.json`) are updated to reflect the target environment. If Entity Framework Core is in use, apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core functionality, including any data access operations, to confirm end-to-end behavior is correct.

### 6. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended .NET version (e.g., `net8.0`). Ensure all three projects target a consistent framework version to avoid compatibility issues.

### 7. Review Removed Windows-Specific Dependencies

Check that no references to Windows-specific APIs or packages (e.g., `System.Web`, `Microsoft.Web.*`, or Windows registry access) remain in the codebase. Search the solution for any such usages:

```bash
grep -r "System.Web" ./app
```

Replace or remove any remaining Windows-specific code with cross-platform equivalents where applicable.

### 8. Validate Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` and any `Startup.cs` to confirm that middleware configuration, authentication, and routing have been correctly migrated to the ASP.NET Core model. Pay particular attention to:

- Session and cookie configuration
- Authentication and authorization middleware
- Static file serving
- Custom HTTP handlers or modules that may have been present in the legacy project