# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to be successful with no build errors reported across any of the projects in the solution (Bookstore.Data, Bookstore.Web, and Bookstore.Domain). This indicates that the migration to cross-platform .NET has completed without compilation issues.

## Validation Steps

### 1. Verify Project Configuration

Review each project file to confirm the transformation settings:

```bash
# Check target framework versions
cat app/Bookstore.Data/Bookstore.Data.csproj
cat app/Bookstore.Domain/Bookstore.Domain.csproj
cat app/Bookstore.Web/Bookstore.Web.csproj
```

Ensure all projects target an appropriate .NET version (net6.0, net7.0, or net8.0).

### 2. Restore and Rebuild

Perform a clean restore and rebuild to verify reproducibility:

```bash
dotnet clean
dotnet restore
dotnet build --configuration Release
```

### 3. Run Unit Tests

Execute any existing unit tests to validate functionality:

```bash
dotnet test --configuration Release --verbosity normal
```

If tests fail, investigate and address issues in the test projects or application code.

### 4. Review Dependencies

Check for deprecated or incompatible NuGet packages:

```bash
dotnet list package --outdated
dotnet list package --deprecated
dotnet list package --vulnerable
```

Update packages as needed:

```bash
dotnet add package <PackageName> --version <LatestVersion>
```

### 5. Validate Runtime Behavior

Run the web application locally:

```bash
cd app/Bookstore.Web
dotnet run
```

Test the following:

- Application starts without errors
- All endpoints respond correctly
- Database connectivity works (if applicable)
- Static files and assets load properly
- Authentication and authorization function as expected

### 6. Check Configuration Files

Review and update configuration files for cross-platform compatibility:

- **appsettings.json**: Verify connection strings and environment-specific settings
- **launchSettings.json**: Confirm port configurations and environment variables
- **web.config**: Remove or archive if no longer needed for .NET Framework IIS hosting

### 7. Review Code for Platform-Specific Issues

Search for potential compatibility issues:

- Windows-specific path separators (use `Path.Combine()` instead of hardcoded backslashes)
- Case-sensitive file system references
- Registry access or Windows-specific APIs
- COM interop or P/Invoke calls

### 8. Test on Target Platforms

If cross-platform support is required, test the application on:

- **Linux**: Deploy and run on a Linux distribution
- **macOS**: Verify functionality on macOS
- **Windows**: Confirm continued Windows compatibility

### 9. Performance Testing

Compare performance metrics between the legacy and migrated versions:

- Response times
- Memory usage
- CPU utilization
- Database query performance

### 10. Update Documentation

Document the migration:

- Update README with new build and run instructions
- Note any breaking changes or configuration updates
- Update deployment documentation
- Record the target framework version and dependencies

## Deployment Preparation

### 1. Create Publish Profile

Generate deployment artifacts:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish \
  --self-contained false
```

For self-contained deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish \
  --self-contained true \
  --runtime linux-x64
```

### 2. Verify Published Output

Check the publish directory:

- All necessary DLLs are present
- Configuration files are included
- Static assets are copied
- The application runs from the publish directory

### 3. Environment Configuration

Prepare environment-specific settings:

- Set environment variables for production
- Configure connection strings securely
- Update logging configurations
- Set up application secrets or key vault integration

### 4. Pre-Deployment Testing

Test the published application in a staging environment that mirrors production:

```bash
cd publish
dotnet Bookstore.Web.dll
```

Verify all functionality works from the published output.

## Post-Migration Monitoring

After deployment, monitor:

- Application logs for errors or warnings
- Performance metrics compared to the legacy version
- User-reported issues
- Resource utilization on the hosting environment

## Additional Considerations

- Review any custom build scripts or tooling that may need updates
- Update developer onboarding documentation
- Verify that all team members can build and run the migrated solution
- Consider establishing a rollback plan for the initial deployment