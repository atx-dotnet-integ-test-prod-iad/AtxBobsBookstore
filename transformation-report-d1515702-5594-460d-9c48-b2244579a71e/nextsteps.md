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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may indicate compatibility concerns, such as obsolete API usage or nullable reference warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test output carefully. Failures here may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas in particular:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, verify that migrations apply cleanly with `dotnet ef database update`.
- **Domain logic**: Exercise the key business logic paths exposed through `Bookstore.Domain` to confirm expected outputs.
- **Web layer**: Navigate through the application's pages or API endpoints and confirm responses are correct.

### 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings have been moved to `appsettings.json` or environment variables.
- Any configuration sections previously in `Web.config` have been migrated appropriately.
- Environment-specific settings (e.g., `appsettings.Development.json`) are in place.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs behave differently or are unavailable on non-Windows platforms. Review the codebase for usage of:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 8. Deployment

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and dependencies are present before deploying to the target environment.