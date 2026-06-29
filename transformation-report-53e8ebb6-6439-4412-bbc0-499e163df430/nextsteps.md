# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build. Common areas to watch for include:

- Deprecated API usage
- Platform-specific APIs that may not behave identically on non-Windows systems
- Nullable reference type warnings if the project has been updated to a newer C# language version

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing behavior has been preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in configuration files (e.g., `appsettings.json`) are correct for the target environment.
- If Entity Framework is used, run or verify any pending migrations:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, etc.) is appropriate for the target platform.

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- Routing and page rendering work as expected.
- Any authentication or authorization mechanisms function correctly.
- Static assets (CSS, JavaScript, images) are served properly.

### 6. Review Configuration Files

Ensure that configuration previously held in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or environment-specific variants such as `appsettings.Production.json`. Pay particular attention to:

- Connection strings
- Application settings keys
- Logging configuration
- Any custom configuration sections

### 7. Check for Platform-Specific Code

If the application will be deployed to Linux or macOS, review the codebase for any Windows-specific dependencies, such as:

- `System.Windows` or `System.Drawing` namespaces
- Windows registry access
- File paths using backslashes instead of `Path.Combine`
- COM interop or P/Invoke calls targeting Windows libraries

### 8. Review Startup and Middleware Configuration

In `Bookstore.Web`, confirm that the ASP.NET Core middleware pipeline in `Program.cs` or `Startup.cs` is configured correctly, including:

- Exception handling middleware
- HTTPS redirection
- Static file serving
- Authentication and authorization middleware order

## Deployment

Once local validation is complete, prepare for deployment by publishing the application:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm that all required assets, configuration files, and binaries are present before deploying to the target environment.