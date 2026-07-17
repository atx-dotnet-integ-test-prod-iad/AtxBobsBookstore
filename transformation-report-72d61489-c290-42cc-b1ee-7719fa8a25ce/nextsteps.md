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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may point to behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the key areas of the application, including:

- Browsing and searching for books
- Any data access operations (reads and writes to the database)
- Any authentication or authorization flows if present

### 5. Check Database Compatibility

Since `Bookstore.Data` is present, verify that your data access layer functions correctly:

- Confirm the connection string in your configuration file (`appsettings.json`) is correct for the target environment.
- If Entity Framework is in use, run any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Verify that data is being read from and written to the database as expected.

### 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm that:

- All configuration values previously in `Web.config` or `App.config` have been moved to `appsettings.json` or environment variables.
- Connection strings, API keys, and other environment-specific settings are correctly defined.
- The `appsettings.json` file is included in the project output.

### 7. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that were specific to Windows and may not behave correctly on other platforms, such as:

- Registry access
- Windows-specific file paths (e.g., hardcoded `C:\` paths)
- `System.Web` references that may have been carried over

### 8. Target Framework Verification

Open each `.csproj` file and confirm that the `TargetFramework` is set to the intended cross-platform version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.