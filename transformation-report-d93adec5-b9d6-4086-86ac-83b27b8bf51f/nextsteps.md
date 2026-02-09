# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Validation and Testing

### 1. Verify Build Success
Since the solution shows no build errors across all three projects (Bookstore.Data, Bookstore.Web, and Bookstore.Domain), the initial transformation appears successful. Confirm this by performing a clean build:

```bash
dotnet clean
dotnet build
```

### 2. Review Target Framework
Verify that all projects are targeting the appropriate .NET version:

```bash
# Check each project file
cat app/Bookstore.Data/Bookstore.Data.csproj
cat app/Bookstore.Domain/Bookstore.Domain.csproj
cat app/Bookstore.Web/Bookstore.Web.csproj
```

Ensure the `<TargetFramework>` element specifies a supported cross-platform version (e.g., `net6.0`, `net7.0`, or `net8.0`).

### 3. Validate Dependencies
Review and test all NuGet package references:

```bash
dotnet list package --outdated
dotnet list package --deprecated
```

Update any outdated or deprecated packages that have cross-platform alternatives.

### 4. Run Unit Tests
Execute all existing unit tests to ensure functionality remains intact:

```bash
dotnet test
```

If tests fail, investigate compatibility issues with test frameworks or dependencies.

### 5. Configuration Files
Review and update configuration files for cross-platform compatibility:

- **app/Bookstore.Web/appsettings.json**: Verify connection strings and paths use forward slashes or `Path.Combine()`
- **web.config**: If present, this file is no longer needed for cross-platform .NET and should be removed or archived

### 6. Database Connectivity
Test database connections, especially if using Entity Framework:

```bash
# Navigate to the Web project
cd app/Bookstore.Web

# Test database migrations
dotnet ef database update --dry-run
```

Verify that connection strings work across different operating systems.

### 7. Static Files and Content
Verify that static file paths are case-sensitive compatible:

- Check file references in Razor views
- Validate wwwroot folder structure
- Test image, CSS, and JavaScript references

### 8. Runtime Testing
Run the application locally on the target platform:

```bash
cd app/Bookstore.Web
dotnet run
```

Test the following:

- Application starts without errors
- All pages load correctly
- Database operations function properly
- Authentication/authorization works as expected
- File I/O operations complete successfully

### 9. Cross-Platform Validation
If possible, test the application on multiple operating systems:

- **Windows**: `dotnet run`
- **Linux**: `dotnet run`
- **macOS**: `dotnet run`

Pay attention to:

- Path separator differences
- Case-sensitive file systems (Linux/macOS)
- Line ending differences in text files

### 10. Performance Baseline
Establish performance metrics for the migrated application:

```bash
dotnet run --configuration Release
```

Monitor:

- Application startup time
- Memory usage
- Response times for key operations

### 11. Prepare for Deployment
Create a publish profile for your target environment:

```bash
# For self-contained deployment
dotnet publish -c Release -r linux-x64 --self-contained

# For framework-dependent deployment
dotnet publish -c Release
```

Test the published output to ensure all dependencies are included.

### 12. Documentation Updates
Update project documentation to reflect:

- New target framework version
- Updated dependency requirements
- Cross-platform setup instructions
- Any breaking changes from the migration

## Common Issues to Watch For

- **Path separators**: Replace hardcoded backslashes with `Path.Combine()` or forward slashes
- **Case sensitivity**: Ensure file and namespace references match actual casing
- **Windows-specific APIs**: Replace with cross-platform alternatives from `System.Runtime.InteropServices`
- **Configuration providers**: Verify environment variable and configuration loading works across platforms

## Final Verification Checklist

- [ ] Solution builds without errors
- [ ] All unit tests pass
- [ ] Application runs successfully
- [ ] Database connectivity works
- [ ] Static files load correctly
- [ ] No Windows-specific dependencies remain
- [ ] Published output runs on target platform
- [ ] Documentation is updated