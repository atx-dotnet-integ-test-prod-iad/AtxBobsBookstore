# Next Steps

## Transformation Status

The transformation appears to have completed successfully with no build errors reported across any of the projects in the solution:

- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`
- `Bookstore.Domain.csproj`

## Validation Steps

### 1. Verify Build Configuration

Run a clean build to ensure all projects compile correctly:

```bash
dotnet clean
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors.

### 2. Review Target Framework

Check that all projects are targeting an appropriate .NET version:

```bash
dotnet list package --framework
```

Ensure consistency across projects and verify they target a supported .NET version (e.g., `net6.0`, `net7.0`, or `net8.0`).

### 3. Validate Dependencies

Review NuGet package references to ensure they are compatible with cross-platform .NET:

```bash
dotnet list package --outdated
dotnet list package --deprecated
```

Update any outdated or deprecated packages as needed.

### 4. Test Functionality

Execute the test suite if one exists:

```bash
dotnet test
```

If no tests exist, consider running the application manually to verify core functionality.

### 5. Check Platform-Specific Code

Search for any remaining platform-specific code or dependencies:

- Review P/Invoke declarations for Windows-specific APIs
- Check for references to `System.Drawing` (consider migrating to `System.Drawing.Common` or cross-platform alternatives)
- Look for file path handling that assumes Windows path separators
- Verify database connection strings and providers are cross-platform compatible

### 6. Validate Runtime Behavior

Run the application on the target platform:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Test key workflows:

- Database connectivity (Bookstore.Data)
- Business logic operations (Bookstore.Domain)
- Web endpoints and UI functionality (Bookstore.Web)

### 7. Cross-Platform Testing

If possible, test the application on multiple operating systems:

- Windows
- Linux
- macOS

This ensures true cross-platform compatibility.

### 8. Configuration Review

Verify configuration files have been updated appropriately:

- Check `appsettings.json` for any environment-specific settings
- Review connection strings for cross-platform database compatibility
- Ensure file paths use `Path.Combine()` rather than hardcoded separators

### 9. Performance Baseline

Establish performance baselines for the migrated application:

- Measure application startup time
- Test database query performance
- Monitor memory usage patterns

Compare these metrics with the legacy application if data is available.

### 10. Documentation

Update project documentation to reflect:

- New target framework version
- Updated build and run instructions
- Any breaking changes in functionality
- New system requirements

## Deployment Preparation

### 1. Publish the Application

Create a release build for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj -c Release -o ./publish
```

### 2. Verify Published Output

Check the publish directory to ensure all necessary files are included:

- Application assemblies
- Configuration files
- Static assets (wwwroot content)
- Required runtime dependencies

### 3. Runtime Deployment

Choose an appropriate deployment model:

- **Framework-dependent**: Requires .NET runtime on target machine (smaller deployment size)
- **Self-contained**: Includes .NET runtime (larger deployment size, no runtime dependency)

For self-contained deployment:

```bash
dotnet publish -c Release -r <RID> --self-contained true
```

Replace `<RID>` with the appropriate runtime identifier (e.g., `linux-x64`, `win-x64`, `osx-x64`).

### 4. Environment Configuration

Prepare environment-specific configuration:

- Set up environment variables for sensitive data
- Configure logging levels appropriately
- Verify database connection strings for production environment

### 5. Final Validation

Perform a final smoke test in a staging environment that mirrors production before deploying to production.