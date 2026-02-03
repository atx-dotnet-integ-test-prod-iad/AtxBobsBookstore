# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to be successful with no build errors reported across any of the projects in the solution (Bookstore.Data, Bookstore.Web, and Bookstore.Domain). This indicates that the migration to cross-platform .NET has completed without compilation issues.

## Validation Steps

### 1. Verify Project Configuration

Review each project file to ensure proper configuration:

```bash
dotnet list package --vulnerable
dotnet list package --deprecated
dotnet list package --outdated
```

Check for:
- Target framework is set correctly (e.g., `net6.0`, `net7.0`, or `net8.0`)
- Package references are using compatible versions
- No deprecated or vulnerable packages are in use

### 2. Run Unit Tests

Execute the existing test suite to verify functionality:

```bash
dotnet test
```

If tests fail:
- Review test output for specific failures
- Check for tests that may have dependencies on Windows-specific APIs
- Update test assertions or mocks that may be framework-specific

### 3. Perform Local Build Verification

Build the solution in different configurations:

```bash
dotnet build --configuration Debug
dotnet build --configuration Release
```

Verify that both configurations build successfully without warnings.

### 4. Runtime Validation

Run the application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Test the following:
- Application starts without errors
- Database connections function correctly (Bookstore.Data)
- All web endpoints respond as expected (Bookstore.Web)
- Business logic executes properly (Bookstore.Domain)

### 5. Cross-Platform Testing

If cross-platform support is a requirement, test on multiple operating systems:

- **Windows**: Verify existing functionality remains intact
- **Linux**: Test in a Linux environment (WSL, VM, or native)
- **macOS**: Test on macOS if available

Pay attention to:
- File path separators (backslash vs forward slash)
- Case-sensitive file system behavior
- Line ending differences

### 6. Database Compatibility

Verify database provider compatibility:

- If using Entity Framework Core, ensure migrations run successfully:
  ```bash
  dotnet ef migrations list --project app/Bookstore.Data
  dotnet ef database update --project app/Bookstore.Data
  ```
- Test database operations (CRUD) through the application
- Verify connection strings are properly configured for the target environment

### 7. Configuration Review

Check application configuration files:

- Verify `appsettings.json` and environment-specific settings
- Ensure connection strings are parameterized
- Review any hardcoded paths or Windows-specific configurations
- Validate environment variable usage

### 8. Dependency Injection and Services

Verify service registration and dependency injection:

- Review `Program.cs` or `Startup.cs` for proper service configuration
- Test that all dependencies resolve correctly at runtime
- Check for any services that may have platform-specific implementations

### 9. Static Code Analysis

Run code analysis to identify potential issues:

```bash
dotnet format --verify-no-changes
dotnet build /p:EnforceCodeStyleInBuild=true
```

Address any warnings or suggestions that appear.

### 10. Performance Baseline

Establish performance baselines for the migrated application:

- Measure application startup time
- Test response times for key endpoints
- Monitor memory usage during typical operations
- Compare with legacy application metrics if available

## Deployment Preparation

### 1. Publish the Application

Create a production build:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj -c Release -o ./publish
```

Verify the published output:
- Check that all necessary files are included
- Ensure `appsettings.Production.json` is present
- Verify static files and wwwroot content are copied

### 2. Runtime Environment

Determine the deployment runtime:

- **Framework-dependent**: Requires .NET runtime on target server
  ```bash
  dotnet publish -c Release
  ```
  
- **Self-contained**: Includes runtime with application
  ```bash
  dotnet publish -c Release --self-contained -r linux-x64
  ```

Choose the appropriate runtime identifier (RID) for your target platform.

### 3. Environment-Specific Configuration

Prepare configuration for target environment:

- Set up environment variables for sensitive data
- Configure connection strings for production database
- Review logging configuration for production
- Disable development-specific features (e.g., detailed error pages)

### 4. Pre-Deployment Checklist

Before deploying to production:

- [ ] All tests pass successfully
- [ ] Application runs without errors locally
- [ ] Database migrations are tested and ready
- [ ] Configuration is externalized and secure
- [ ] Performance meets acceptable thresholds
- [ ] Error handling and logging are properly configured
- [ ] Security headers and HTTPS are configured (for web applications)

### 5. Deployment Execution

Deploy to your target environment:

- Copy published files to the server
- Install .NET runtime if using framework-dependent deployment
- Configure the web server (IIS, Nginx, Apache, Kestrel)
- Apply database migrations to production database
- Start the application and monitor logs

### 6. Post-Deployment Validation

After deployment:

- Verify the application is accessible
- Test critical user workflows
- Monitor application logs for errors
- Check performance metrics
- Validate database connectivity and operations

## Ongoing Maintenance

- Keep .NET runtime and packages updated
- Monitor for security advisories
- Review and address any runtime warnings in logs
- Maintain test coverage as features are added