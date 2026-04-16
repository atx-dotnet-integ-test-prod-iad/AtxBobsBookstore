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

Check the output for any warnings that may indicate compatibility concerns, even if they do not prevent compilation.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific APIs

Search the codebase for any APIs that are Windows-specific and may not function correctly on Linux or macOS. Common areas to check include:

- `System.Web` namespace usage
- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., backslashes)
- `HttpContext` usage patterns that were specific to ASP.NET (non-Core)

You can use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this.

### 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate runtime behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they indicate a regression introduced during the transformation.

### 6. Validate the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the following:

- Entity Framework Core (or whichever ORM is in use) is correctly configured for the new runtime.
- Database migrations are present and up to date. Run the following to check migration status:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add PostMigration --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Web Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary workflows, particularly any that involve database reads and writes, to confirm end-to-end functionality.

### 8. Review Configuration Files

Confirm that `appsettings.json` contains all configuration values that were previously held in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

The legacy `<connectionStrings>` and `<appSettings>` sections from `Web.config` should now be represented in `appsettings.json` using the appropriate JSON structure.

### 9. Verify Static Files and Routing

If `Bookstore.Web` is an ASP.NET Core application, confirm that:

- Static file middleware is enabled in `Program.cs` or `Startup.cs`.
- Routing is configured correctly and all expected endpoints resolve.
- Any Razor views or pages render without errors.