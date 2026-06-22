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

Run a full solution build to confirm the absence of any build-time issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, check the following areas:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is used, verify that migrations apply cleanly with `dotnet ef database update`.
- **Domain logic**: Exercise the key domain workflows to confirm correct behavior.
- **Web layer**: Navigate through the application's routes and verify that pages or API endpoints return expected results.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm that:

- Application settings have been moved to `appsettings.json`.
- Connection strings are correctly defined and accessible at runtime.
- Any environment-specific configuration (e.g., `appsettings.Development.json`) is in place.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs may behave differently or throw at runtime on non-Windows platforms. Review the codebase for usage of:

- `System.Drawing` (GDI+ is not fully supported cross-platform without additional packages).
- Windows Registry access.
- Windows-specific file path assumptions (e.g., backslash separators).
- COM interop or P/Invoke calls targeting Windows-only libraries.

Use `dotnet` compatibility analyzers if a thorough audit is needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

### 7. Target Framework Confirmation

Open each `.csproj` file and confirm that the `TargetFramework` element is set to a current and supported version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If an older version such as `net6.0` is present, consider updating to a long-term support (LTS) release.