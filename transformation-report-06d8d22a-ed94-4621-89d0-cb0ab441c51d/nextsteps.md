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

Run a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- Database connections established by `Bookstore.Data` are functioning correctly.
- Domain logic in `Bookstore.Domain` produces expected results.
- All routes and pages in `Bookstore.Web` load without errors.

### 5. Check Target Framework Compatibility

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Review NuGet Package Versions

Check that all NuGet packages referenced across the three projects are compatible with the target framework. Pay particular attention to:

- Any packages that were previously Windows-specific.
- Entity Framework or database provider packages in `Bookstore.Data`.
- Any packages in `Bookstore.Web` related to authentication, session, or HTTP handling.

### 7. Inspect Configuration Files

Review `appsettings.json` and any environment-specific configuration files in `Bookstore.Web` to ensure:

- Connection strings are valid for the target environment.
- Any file paths use cross-platform path handling rather than hardcoded Windows-style paths.

### 8. Test on Target Platform

If the intended deployment platform is Linux or macOS, run the application on that platform or an equivalent environment to surface any remaining platform-specific issues that would not appear on Windows.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Verify the published output runs correctly on the target operating system.