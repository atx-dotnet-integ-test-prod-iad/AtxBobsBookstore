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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform equivalents.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Connection strings in `appsettings.json` are correct for the target environment.

### 6. Run the Web Application Locally (Bookstore.Web)

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and exercise the primary workflows to check for runtime exceptions that would not surface at build time.

### 7. Check for Windows-Specific API Usage

Even without build errors, some APIs that compiled successfully may not behave correctly on non-Windows platforms. Review the codebase for usage of the following and test on the target OS if applicable:

- `System.Drawing` (GDI+ is not fully supported cross-platform without additional packages)
- Windows registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `HttpContext.Current` (not available in ASP.NET Core)

### 8. Review Startup and Middleware Configuration

If `Bookstore.Web` was migrated from ASP.NET MVC (.NET Framework) to ASP.NET Core, verify that:

- `Program.cs` and/or `Startup.cs` correctly configure services and middleware.
- Authentication, authorization, and session middleware are properly registered.
- Static file serving is configured if the application serves CSS, JavaScript, or images.

### 9. Inspect Logging and Configuration

Confirm that any legacy `Web.config` or `App.config` values have been migrated to `appsettings.json` and are being read correctly using `IConfiguration`.

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all required files, static assets, and configuration files are present.

### 3. Test the Published Output

Run the published output directly to confirm it behaves identically to the development build:

```bash
dotnet ./publish/Bookstore.Web.dll
```