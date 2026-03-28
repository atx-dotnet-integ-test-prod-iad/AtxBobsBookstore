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

Check the output for any warnings that, while non-blocking, may indicate deprecated APIs or compatibility concerns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following areas at a minimum:

- Application startup and landing page load
- Database connectivity through `Bookstore.Data` (check connection strings in `appsettings.json`)
- Core domain logic exposed through `Bookstore.Domain`
- Any authentication or session-based functionality
- Static file serving (CSS, JavaScript, images)

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm that:

- All connection strings have been migrated to `appsettings.json`
- Any environment-specific settings are handled via `appsettings.{Environment}.json` or environment variables
- `Web.config` transforms or `appSettings` entries from the legacy project have been accounted for

### 6. Check Entity Framework Migrations

If `Bookstore.Data` uses Entity Framework, verify that migrations are compatible with the current provider:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database provider was changed during migration (for example, from `System.Data.SqlClient` to `Microsoft.Data.SqlClient`), test database operations thoroughly to confirm correct behavior.

### 7. Review Removed Windows-Specific Dependencies

Inspect each project for any references to APIs that were available in .NET Framework but have limited or no support in cross-platform .NET, such as:

- `System.Web` namespaces
- Windows Communication Foundation (WCF) server-side components
- `HttpContext` usage patterns that differ between `System.Web` and `Microsoft.AspNetCore.Http`

Address any runtime exceptions that surface from these areas during manual testing.

### 8. Target Framework Verification

Confirm that all projects are targeting the intended .NET version by reviewing each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` to avoid cross-framework reference issues.

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all required files are present, including:

- The application binary and its dependencies
- The `wwwroot` folder with static assets
- The `appsettings.json` configuration file

### 3. Deploy to the Target Environment

Copy the publish output to the target server or hosting environment. Ensure the target machine has the correct .NET runtime installed:

```bash
dotnet --list-runtimes
```

The required runtime version should match the `TargetFramework` specified in the web project. If it is not present, download and install it from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).

### 4. Configure the Web Server

If hosting on IIS, install the [ASP.NET Core Hosting Bundle](https://dotnet.microsoft.com/download) on the server and configure the IIS site to point to the publish output directory. Confirm the application pool is set to **No Managed Code**, as the ASP.NET Core module manages the process directly.

If hosting on Linux with a reverse proxy such as Nginx or Apache, configure the proxy to forward requests to the Kestrel process on the appropriate port.