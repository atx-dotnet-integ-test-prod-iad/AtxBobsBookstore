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

Run a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas in particular:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is used, verify that migrations apply cleanly with `dotnet ef database update`.
- **Domain logic**: Exercise the key business logic paths exposed by `Bookstore.Domain` to confirm expected behavior.
- **Web layer**: Navigate through the application pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Cross-platform .NET does not use `Web.config` or `App.config` in the same way as .NET Framework. Confirm that:

- Configuration has been migrated to `appsettings.json` or environment variables.
- Connection strings are correctly defined and accessible at runtime.
- Any environment-specific settings (e.g., development vs. production) are handled via `appsettings.{Environment}.json`.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs may behave differently or throw at runtime on non-Windows platforms. Review the codebase for usage of:

- `System.Drawing` (requires additional native dependencies on Linux/macOS)
- Windows Registry access
- Windows-specific file path assumptions (backslashes, drive letters)
- COM interop or P/Invoke calls targeting Windows libraries

Replace or conditionally guard any such usages if cross-platform deployment is a requirement.

### 7. Review Warnings in Build Output

Re-examine the build output for any warnings flagged during the `dotnet build` step. Common areas to address include:

- Nullable reference type warnings if the project has opted into nullable context
- Obsolete API usage that may be removed in future .NET versions
- Package version conflicts or deprecated transitive dependencies