# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to be successful with no build errors reported across any of the projects in the solution (Bookstore.Data, Bookstore.Web, and Bookstore.Domain). This is a positive indicator that the migration to cross-platform .NET has completed without compilation issues.

## Validation Steps

### 1. Verify Project Structure and Dependencies

- Open each `.csproj` file and confirm the `TargetFramework` is set to a modern .NET version (e.g., `net6.0`, `net7.0`, or `net8.0`)
- Review all `PackageReference` entries to ensure NuGet packages are compatible with the target framework
- Check that project references between Bookstore.Web, Bookstore.Domain, and Bookstore.Data are correctly defined

### 2. Build Verification

Execute a clean build to confirm reproducibility:

```bash
dotnet clean
dotnet restore
dotnet build --configuration Release
```

Verify that all projects build successfully without warnings related to deprecated APIs or platform-specific code.

### 3. Code Review for Platform-Specific Issues

Review the codebase for potential runtime issues that may not appear as build errors:

- **Configuration**: Verify `appsettings.json` and any environment-specific configuration files are present and correctly formatted
- **Database connections**: Check connection strings in Bookstore.Data for compatibility with cross-platform environments
- **File paths**: Search for hardcoded Windows-style paths (e.g., `C:\` or `\`) and replace with `Path.Combine()` or forward slashes
- **Case sensitivity**: File and directory references should account for case-sensitive file systems (Linux/macOS)
- **Windows-specific APIs**: Search for any remaining references to Windows-only namespaces or APIs

### 4. Run Unit and Integration Tests

If the solution includes test projects:

```bash
dotnet test
```

If no test projects exist, consider creating basic tests for critical functionality in each layer:

- Bookstore.Domain: Business logic and entity validation
- Bookstore.Data: Database operations and repository patterns
- Bookstore.Web: Controller endpoints and routing

### 5. Local Runtime Testing

Start the application locally to verify runtime behavior:

```bash
cd app/Bookstore.Web
dotnet run
```

Test the following:

- Application starts without exceptions
- Database connectivity (if applicable)
- Web endpoints respond correctly
- Static files and assets load properly
- Logging functionality works as expected

### 6. Cross-Platform Validation

If possible, test the application on different operating systems:

- Build and run on Windows
- Build and run on Linux (using WSL, VM, or native Linux)
- Build and run on macOS (if available)

This ensures true cross-platform compatibility.

### 7. Database Migration Verification

For the Bookstore.Data project:

- If using Entity Framework Core, verify migrations are present and valid:
  ```bash
  dotnet ef migrations list --project app/Bookstore.Data
  ```
- Test applying migrations to a development database:
  ```bash
  dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
  ```
- Verify that database schema matches expectations

### 8. Dependency Audit

Check for outdated or vulnerable packages:

```bash
dotnet list package --outdated
dotnet list package --vulnerable
```

Update packages as necessary while testing for breaking changes.

### 9. Performance Baseline

Establish performance metrics for the migrated application:

- Measure application startup time
- Test response times for key endpoints
- Monitor memory usage during typical operations
- Compare with legacy application metrics if available

### 10. Documentation Updates

Update project documentation to reflect the migration:

- README file with new build and run instructions
- Development environment setup for cross-platform .NET
- Any changes to deployment procedures
- Updated system requirements

## Deployment Preparation

### Pre-Deployment Checklist

- [ ] All configuration files are environment-appropriate
- [ ] Connection strings use environment variables or secure configuration providers
- [ ] Logging is configured for the target environment
- [ ] Error handling is appropriate for production use
- [ ] Security headers and HTTPS redirection are enabled (for Bookstore.Web)

### Publish the Application

Create a release build:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Test the published output:

```bash
cd publish
dotnet Bookstore.Web.dll
```

### Framework-Dependent vs Self-Contained

Decide on deployment model:

- **Framework-dependent**: Requires .NET runtime on target server (smaller deployment size)
  ```bash
  dotnet publish --configuration Release
  ```

- **Self-contained**: Includes .NET runtime (larger deployment, no runtime dependency)
  ```bash
  dotnet publish --configuration Release --self-contained true --runtime linux-x64
  ```

Choose the runtime identifier (RID) appropriate for your deployment target (e.g., `win-x64`, `linux-x64`, `osx-x64`).

## Final Recommendations

- Implement monitoring and logging in the production environment to catch any runtime issues not discovered during testing
- Create a rollback plan in case issues are discovered post-deployment
- Consider a phased rollout if deploying to production (e.g., canary deployment or blue-green deployment)
- Schedule a post-deployment review to document lessons learned and any remaining technical debt