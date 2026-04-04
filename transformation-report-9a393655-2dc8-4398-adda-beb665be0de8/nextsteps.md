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

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting a consistent and supported version of .NET.

### 5. Check for Runtime-Specific Dependencies

Review `Bookstore.Data` and `Bookstore.Web` for any dependencies that were previously Windows-specific, such as:

- `System.Web` references or HTTP modules/handlers
- Windows Authentication or IIS-specific configuration
- Registry access or Windows-only file paths
- Entity Framework 6 (which should be migrated to EF Core if not already done)

### 6. Verify Database Connectivity

If `Bookstore.Data` uses a database, confirm that:

- The connection string in `appsettings.json` is correct for the target environment
- Any required database migrations are up to date by running:

```bash
dotnet ef database update
```

### 7. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the locally hosted URL and confirm that key pages and features load and function correctly, including any data-driven pages that rely on `Bookstore.Data` and `Bookstore.Domain`.

### 8. Review Middleware and Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) to confirm:

- Middleware is registered in the correct order
- Authentication and authorization configuration is valid
- Static file serving is configured if the application serves frontend assets

### 9. Cross-Platform Smoke Test

If cross-platform support is a goal, run the application on a non-Windows environment (Linux or macOS) to identify any remaining platform-specific issues that may not surface as build errors but will cause runtime failures.

### 10. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server and configure the hosting environment (such as Kestrel behind a reverse proxy like Nginx or IIS) according to the official Microsoft ASP.NET Core hosting documentation.