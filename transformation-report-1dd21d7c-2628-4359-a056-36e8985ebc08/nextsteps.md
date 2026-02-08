# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to be successful with no build errors reported across any of the projects in the solution (Bookstore.Data, Bookstore.Web, and Bookstore.Domain). This is a positive indicator that the migration to cross-platform .NET has completed without compilation issues.

## Validation Steps

### 1. Verify Project Configuration

Review the `.csproj` files to ensure they are using the correct target framework:

```bash
# Check that all projects target a modern .NET version (net6.0, net7.0, or net8.0)
grep -r "<TargetFramework>" app/**/*.csproj
```

Confirm that:
- All projects use SDK-style project files
- Target framework is set to a supported .NET version
- Package references have been updated to compatible versions

### 2. Run Unit Tests

Execute all existing unit tests to verify functionality:

```bash
dotnet test
```

Address any test failures by:
- Updating test assertions that may behave differently in cross-platform .NET
- Checking for platform-specific dependencies
- Verifying mock configurations are still valid

### 3. Perform Runtime Testing

Run the application locally to identify runtime issues that may not appear during compilation:

```bash
# For the web project
cd app/Bookstore.Web
dotnet run
```

Test the following areas:
- Database connectivity (Bookstore.Data)
- Entity Framework migrations and queries
- Web endpoints and routing
- Authentication and authorization flows
- File I/O operations (verify path separators work cross-platform)

### 4. Check for Platform-Specific Code

Search for potential platform-specific implementations:

```bash
# Look for Windows-specific APIs
grep -r "System.Windows" app/
grep -r "Microsoft.Win32" app/

# Check for hardcoded path separators
grep -r '\\\\' app/**/*.cs
```

Replace any findings with cross-platform alternatives:
- Use `Path.Combine()` instead of hardcoded path separators
- Replace Windows-specific APIs with cross-platform equivalents

### 5. Validate Dependencies

Review all NuGet package references:

```bash
dotnet list package --outdated
dotnet list package --deprecated
```

Actions to take:
- Update any outdated packages to versions compatible with your target framework
- Replace deprecated packages with recommended alternatives
- Remove any packages that are no longer necessary

### 6. Test on Multiple Platforms

If possible, test the application on different operating systems:

- **Windows**: Verify existing functionality remains intact
- **Linux**: Test in a Linux environment (Ubuntu, Alpine, etc.)
- **macOS**: Validate on macOS if applicable

Pay attention to:
- Case-sensitive file system differences on Linux/macOS
- Line ending differences (CRLF vs LF)
- Environment variable access patterns

### 7. Database Migration Verification

For the Bookstore.Data project, verify Entity Framework migrations:

```bash
cd app/Bookstore.Data
dotnet ef migrations list
dotnet ef database update --dry-run
```

Ensure:
- All migrations are compatible with the new .NET version
- Database provider packages are updated appropriately
- Connection strings work across platforms

### 8. Configuration Review

Check application configuration files:

- Verify `appsettings.json` and environment-specific variants load correctly
- Test configuration binding to strongly-typed objects
- Confirm environment variables are read properly
- Validate secrets management approach is platform-agnostic

### 9. Performance Baseline

Establish performance baselines for the migrated application:

```bash
dotnet run --configuration Release
```

Monitor:
- Application startup time
- Memory consumption
- Response times for key endpoints
- Database query performance

Compare these metrics with the legacy application to identify any regressions.

## Deployment Preparation

### 1. Update Deployment Documentation

Document the new deployment requirements:
- Target framework runtime requirements
- Updated dependency list
- New environment variables or configuration settings
- Platform-specific considerations

### 2. Create Publish Profiles

Generate publish profiles for your target environments:

```bash
# Self-contained deployment
dotnet publish -c Release -r linux-x64 --self-contained

# Framework-dependent deployment
dotnet publish -c Release
```

Test the published output to ensure all necessary files are included.

### 3. Update Server Requirements

Ensure target servers meet the requirements:
- Install the appropriate .NET runtime version
- Verify system dependencies are available
- Update any reverse proxy configurations (IIS, Nginx, Apache)
- Review security settings and permissions

### 4. Prepare Rollback Plan

Document a rollback procedure:
- Backup current production environment
- Create database backup before migration
- Document steps to revert to legacy version if needed
- Establish success criteria for the deployment

## Final Checks

Before deploying to production:

- [ ] All unit tests pass
- [ ] Integration tests complete successfully
- [ ] Manual testing completed on all critical paths
- [ ] Performance meets or exceeds legacy application
- [ ] Cross-platform testing completed (if applicable)
- [ ] Documentation updated
- [ ] Deployment runbook prepared
- [ ] Rollback plan documented
- [ ] Monitoring and logging configured

## Conclusion

With no build errors present, the transformation has successfully completed the compilation phase. Focus your efforts on thorough runtime testing and validation to ensure the application behaves correctly in the new .NET environment. Pay particular attention to areas that may have platform-specific behavior or dependencies that differ between .NET Framework and modern .NET.