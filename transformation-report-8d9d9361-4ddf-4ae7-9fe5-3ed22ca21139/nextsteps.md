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

## Validation Steps

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- The correct database provider NuGet package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent).
- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 5. Check Runtime Behavior of the Web Project

Start the web application locally and verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate to the application in a browser and test key user-facing features such as browsing, searching, and any authentication flows.
- Check the console output and application logs for any runtime exceptions that would not surface at build time.

### 6. Review Configuration Files

Confirm that the following have been correctly migrated from any legacy `Web.config` or `App.config` files:

- Connection strings are present in `appsettings.json`.
- Any application settings keys previously in `<appSettings>` have been moved to `appsettings.json` and are being read via `IConfiguration`.
- Any HTTP handlers, modules, or custom `system.web` configurations have been replaced with the appropriate ASP.NET Core middleware.

### 7. Review Removed or Changed APIs

Cross-platform .NET does not support certain .NET Framework APIs. Manually inspect the codebase for usage of the following common incompatible areas:

- `System.Web` namespace usage outside of ASP.NET Core abstractions.
- `HttpContext.Current` — replace with injected `IHttpContextAccessor`.
- `ConfigurationManager` — replace with `IConfiguration`.
- Binary serialization via `BinaryFormatter` — this is disabled by default and should be replaced with a supported serialization mechanism.

### 8. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 9. Deploy to a Staging Environment

Once local validation is complete, deploy the application to a staging environment that mirrors production:

- Publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

- Copy the output to the staging server and run the application, verifying that it connects to the database and serves requests correctly.
- Review staging logs for any environment-specific issues such as missing environment variables or misconfigured paths.