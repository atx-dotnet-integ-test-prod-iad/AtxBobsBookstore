# Next Steps

## Validation and Testing

Congratulations on successfully transforming your Bookstore solution to cross-platform .NET. Since no build errors were detected across any of the projects (Bookstore.Data, Bookstore.Domain, and Bookstore.Web), you can proceed with validation and testing.

### 1. Verify Build Configuration

```bash
# Clean and rebuild the entire solution
dotnet clean
dotnet build --configuration Release
```

Ensure both Debug and Release configurations build successfully.

### 2. Verify Project Dependencies

Check that the project references are correctly established:

```bash
# Restore all NuGet packages
dotnet restore
```

Review the `.csproj` files to confirm:
- Target framework is set appropriately (e.g., `net6.0`, `net7.0`, or `net8.0`)
- Package references have compatible versions
- Project-to-project references are correct (Bookstore.Web → Bookstore.Domain → Bookstore.Data)

### 3. Run Unit Tests

If your solution includes test projects:

```bash
# Run all tests
dotnet test

# Run with detailed output
dotnet test --verbosity normal
```

If tests fail, investigate:
- API changes in migrated dependencies
- Behavioral differences between .NET Framework and .NET
- Database connection strings and provider compatibility

### 4. Validate Data Layer (Bookstore.Data)

- **Database Connectivity**: Test connections to your database with the new runtime
- **Entity Framework**: If using EF Core, verify migrations are compatible:
  ```bash
  dotnet ef migrations list --project Bookstore.Data
  ```
- **Data Access Patterns**: Test CRUD operations to ensure data layer functionality is intact

### 5. Validate Domain Layer (Bookstore.Domain)

- Review business logic for any framework-specific dependencies that may behave differently
- Test domain services and validation logic
- Verify any serialization/deserialization operations work as expected

### 6. Validate Web Layer (Bookstore.Web)

- **Run the Application Locally**:
  ```bash
  dotnet run --project Bookstore.Web
  ```
- **Test Key Functionality**:
  - Authentication and authorization flows
  - API endpoints (if applicable)
  - Static file serving
  - View rendering (if using MVC/Razor)
  - Session management
  - Configuration loading from `appsettings.json`

### 7. Check Configuration Files

Review and update configuration:
- **appsettings.json**: Verify connection strings, logging configuration, and application settings
- **web.config**: Remove or archive if no longer needed (IIS-specific settings may need migration to `appsettings.json`)
- **Environment Variables**: Ensure environment-specific configurations work correctly

### 8. Review Dependencies and Compatibility

Check for deprecated or incompatible packages:

```bash
# List outdated packages
dotnet list package --outdated
```

Address any packages that:
- Are marked as deprecated
- Have known vulnerabilities
- Have major version updates available

### 9. Performance and Compatibility Testing

- **Cross-Platform Testing**: Run the application on different operating systems (Windows, Linux, macOS) if cross-platform support is required
- **Runtime Behavior**: Monitor for differences in:
  - File path handling (use `Path.Combine` instead of string concatenation)
  - Case sensitivity in file systems
  - Line ending differences
  - Culture and localization behavior

### 10. Update Documentation

- Update README files with new build and run instructions
- Document the target framework version
- Note any breaking changes or required configuration updates
- Update deployment documentation to reflect .NET (Core) deployment requirements

## Deployment Preparation

### 1. Publish the Application

Test the publish process:

```bash
# Publish for framework-dependent deployment
dotnet publish Bookstore.Web -c Release -o ./publish

# Publish as self-contained (includes runtime)
dotnet publish Bookstore.Web -c Release -r win-x64 --self-contained true -o ./publish-win
dotnet publish Bookstore.Web -c Release -r linux-x64 --self-contained true -o ./publish-linux
```

### 2. Verify Published Output

- Test the published application runs correctly
- Verify all necessary files are included (configuration, static assets, etc.)
- Check the output size is reasonable

### 3. Update Hosting Configuration

If deploying to IIS:
- Install the .NET Hosting Bundle on the server
- Update application pool settings (No Managed Code)
- Verify `web.config` is generated during publish

If deploying to other hosts:
- Verify the hosting environment supports your target framework
- Configure reverse proxy settings if applicable (Nginx, Apache)
- Set up appropriate service management (systemd, Windows Service)

### 4. Environment-Specific Testing

- Deploy to a staging environment first
- Perform smoke tests on all critical functionality
- Monitor application logs for warnings or errors
- Validate database migrations in the target environment

### 5. Rollback Plan

- Keep the legacy .NET Framework version available
- Document the rollback procedure
- Maintain backups of configuration and database state

## Final Checklist

- [ ] Solution builds without errors in Debug and Release
- [ ] All unit tests pass
- [ ] Application runs locally without errors
- [ ] Database connectivity verified
- [ ] Key user workflows tested
- [ ] Configuration files reviewed and updated
- [ ] Application published successfully
- [ ] Staging environment deployment tested
- [ ] Documentation updated
- [ ] Rollback plan prepared