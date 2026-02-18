# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to be successful with no build errors reported across any of the projects in the solution (Bookstore.Data, Bookstore.Web, and Bookstore.Domain). This indicates that the migration to cross-platform .NET has completed without compilation issues.

## Validation Steps

### 1. Verify Project Configuration

Review the `.csproj` files to ensure they are using the correct target framework:

```bash
# Check that all projects target a modern .NET version (net6.0, net7.0, or net8.0)
grep -r "<TargetFramework>" app/**/*.csproj
```

Confirm that:
- All projects use the SDK-style project format
- Package references have been updated to compatible versions
- Any legacy .NET Framework-specific references have been removed

### 2. Run Unit Tests

Execute all existing unit tests to verify functionality:

```bash
dotnet test
```

Address any test failures by:
- Updating test frameworks to compatible versions (e.g., MSTest, NUnit, xUnit)
- Reviewing tests that depend on .NET Framework-specific behavior
- Checking for differences in API behavior between .NET Framework and modern .NET

### 3. Perform Local Runtime Testing

Build and run the application locally:

```bash
# Restore dependencies
dotnet restore

# Build the solution
dotnet build

# Run the web application
cd app/Bookstore.Web
dotnet run
```

Test the following:
- Application starts without runtime exceptions
- Database connections function correctly (Bookstore.Data)
- Web endpoints respond as expected (Bookstore.Web)
- Business logic executes properly (Bookstore.Domain)

### 4. Validate Database Connectivity

If the application uses Entity Framework or another ORM:

- Verify connection strings are compatible with cross-platform .NET
- Test database migrations if applicable
- Confirm that database providers (SQL Server, PostgreSQL, etc.) work on the target platform
- Check for any platform-specific SQL or database interaction code

### 5. Review Dependencies

Audit NuGet packages for compatibility:

```bash
dotnet list package --outdated
```

- Update packages to their latest stable versions where appropriate
- Remove any packages that are no longer needed
- Replace any .NET Framework-specific packages with cross-platform alternatives

### 6. Test on Target Platforms

Run the application on all intended deployment platforms:

- **Windows**: Verify existing functionality is preserved
- **Linux**: Test for path separator issues, case-sensitive file systems, and platform-specific APIs
- **macOS**: Validate if this is a target platform

Check for:
- File path handling (use `Path.Combine` instead of string concatenation)
- Case sensitivity in file and resource names
- Platform-specific API calls that may need conditional compilation

### 7. Configuration and Settings

Review application configuration:

- Verify `appsettings.json` and environment-specific configuration files
- Check that configuration binding works correctly
- Validate environment variable usage
- Test configuration reload scenarios if applicable

### 8. Static File and Resource Handling

For the web project (Bookstore.Web):

- Confirm static files are served correctly
- Verify wwwroot folder structure and contents
- Test any embedded resources
- Validate client-side assets load properly

### 9. Performance Baseline

Establish performance metrics:

- Measure application startup time
- Monitor memory usage patterns
- Compare response times with the legacy application
- Identify any performance regressions

### 10. Security Review

Conduct a security assessment:

- Verify authentication and authorization mechanisms function correctly
- Test HTTPS configuration and certificate handling
- Review any cryptography code for API changes
- Validate CORS policies if applicable

## Deployment Preparation

### 1. Create Publish Profiles

Generate deployment artifacts:

```bash
# Self-contained deployment (includes runtime)
dotnet publish -c Release -r linux-x64 --self-contained

# Framework-dependent deployment (requires .NET runtime on target)
dotnet publish -c Release
```

### 2. Document Runtime Requirements

Create documentation specifying:

- Required .NET runtime version
- Operating system requirements
- Database version compatibility
- External service dependencies

### 3. Environment Configuration

Prepare environment-specific settings:

- Create separate `appsettings.{Environment}.json` files
- Document required environment variables
- Set up connection strings for each environment
- Configure logging levels appropriately

### 4. Deployment Validation Checklist

Before deploying to production:

- [ ] All unit tests pass
- [ ] Integration tests complete successfully
- [ ] Application runs on target platform
- [ ] Database connectivity verified
- [ ] Configuration management tested
- [ ] Performance meets baseline requirements
- [ ] Security review completed
- [ ] Rollback plan documented

## Troubleshooting Common Issues

If issues arise during validation:

- **Runtime exceptions**: Check for API differences between .NET Framework and modern .NET using the Microsoft documentation
- **Missing assemblies**: Verify all NuGet packages are restored correctly
- **Configuration errors**: Ensure configuration providers are registered in `Program.cs` or `Startup.cs`
- **Database issues**: Confirm connection strings use compatible formats and providers are installed

## Additional Resources

Consult the following documentation:

- [Breaking changes in .NET](https://docs.microsoft.com/en-us/dotnet/core/compatibility/)
- [Migrate from ASP.NET to ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/migration/proper-to-2x/)
- [.NET application publishing overview](https://docs.microsoft.com/en-us/dotnet/core/deploying/)