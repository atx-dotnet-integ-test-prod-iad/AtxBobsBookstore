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

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that may indicate compatibility issues even if the build succeeds, such as obsolete API usage or platform-specific warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at runtime:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is used, verify that migrations apply cleanly with `dotnet ef database update`.
- **Domain logic**: Exercise the core domain operations through the UI or API endpoints to confirm expected behavior.
- **Web layer**: Navigate through the application pages or endpoints to check for runtime exceptions, missing middleware, or misconfigured services.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- Application settings have been moved to `appsettings.json` or environment variables.
- Connection strings are correctly defined and accessible at runtime.
- Any `Web.config` transforms or `configSource` references have been replaced with the appropriate `IConfiguration` equivalents.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs behave differently or are unsupported on non-Windows platforms. Review the codebase for usage of:

- `System.Web` types that may have been shimmed or replaced.
- Windows Registry access.
- Windows-specific file path assumptions (e.g., backslashes, drive letters).
- `System.Drawing` (GDI+), which has limited support outside of Windows without additional packages such as `System.Drawing.Common`.

Run the application on the target platform (Linux or macOS if applicable) to surface any platform-specific issues that would not appear on Windows.

### 7. Review Startup and Middleware Configuration

If the project was migrated from ASP.NET (System.Web) to ASP.NET Core, verify that:

- `Program.cs` and `Startup.cs` (or the combined minimal hosting model) correctly register all required services.
- Authentication, authorization, session, and routing middleware are configured in the correct order.
- HTTP handlers and modules from the legacy project have been replaced with the equivalent ASP.NET Core middleware.

### 8. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported framework version.