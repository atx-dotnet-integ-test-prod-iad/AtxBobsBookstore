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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility, as these can indicate latent issues even when the build succeeds.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures after migration often point to behavioral differences between .NET Framework and cross-platform .NET in areas such as:

- File path handling (`\` vs `/`)
- Culture and globalization defaults
- Reflection behavior
- `HttpContext` or web-related APIs

### 4. Verify Database Connectivity (Bookstore.Data)

Since the solution includes a `Bookstore.Data` project, verify that the data layer functions correctly:

- Confirm the connection string in your configuration file (`appsettings.json`) is correct for your target environment.
- If Entity Framework is used, run the following to check for pending migrations or schema issues:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If a different ORM or ADO.NET is used, manually test basic read and write operations against your database.

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project and verify core functionality through the browser:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- Application startup and routing
- Authentication and authorization flows, if present
- Any file system access (uploads, static files, etc.), as paths may behave differently on non-Windows systems
- Session and cookie handling

### 6. Review Configuration Files

Ensure that any configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Connection strings
- Application settings keys
- Custom configuration sections

### 7. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or dependencies that may not have been caught during transformation:

- `Microsoft.Win32` namespace usage
- Windows registry access
- COM interop
- `System.Web` references (should no longer be present in cross-platform .NET)

You can use the .NET Upgrade Assistant compatibility analyzer or the following command to check for platform compatibility warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

### 8. Test on Target Platform

If the goal is to run this application on Linux or macOS, perform a test run on that operating system to surface any remaining platform-specific issues that may not appear on Windows.