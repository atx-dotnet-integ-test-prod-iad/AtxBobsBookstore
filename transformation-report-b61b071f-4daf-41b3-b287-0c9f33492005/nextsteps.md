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

Perform a full solution build to confirm the error-free state observed during transformation holds in your local environment:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- Connection strings in configuration files (e.g., `appsettings.json`) are correct and accessible in the new environment.
- Any Entity Framework migrations are up to date. Run the following if using EF Core:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that no `System.Data` or `System.Configuration` APIs were carried over that may behave differently on non-Windows platforms.

### 5. Review `Bookstore.Domain` for Platform-Specific Code

Check the domain project for any remaining usage of Windows-specific APIs or libraries that may not be available cross-platform. Common areas to inspect include:

- File path handling (use `Path.Combine` rather than hardcoded separators)
- Registry access
- Windows identity or security APIs

### 6. Run the Web Application Locally

Start the web application to verify it runs correctly under the new runtime:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise core functionality, paying attention to:

- Database connectivity
- Any file system interactions
- Authentication and authorization flows
- Logging output for runtime exceptions

### 7. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all settings that were previously held in `Web.config` or `App.config`. Key areas include:

- Connection strings
- Logging configuration
- Application-specific settings

### 8. Check for Removed or Changed APIs

Review the [.NET Upgrade Assistant compatibility analyzer results](https://learn.microsoft.com/en-us/dotnet/core/porting/) or use the `Microsoft.DotNet.PlatformAbstractions` compatibility tooling to identify any APIs that exist in the compiled output but may throw `PlatformNotSupportedException` at runtime on non-Windows systems.