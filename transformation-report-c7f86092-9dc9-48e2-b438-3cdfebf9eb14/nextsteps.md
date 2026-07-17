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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Check the output for any warnings, even if there are no errors. Warnings related to nullable reference types or obsolete APIs may indicate areas that need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results carefully. Any failing tests that previously passed may indicate a behavioral difference introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in `appsettings.json` and ensure they are appropriate for the target environment.
- **Domain logic**: Exercise the key domain operations through the UI or API endpoints to confirm expected behavior.
- **Web layer**: Navigate through the application pages or endpoints and confirm that routing, model binding, and views or responses render correctly.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- Connection strings and application settings have been moved to `appsettings.json`.
- Any environment-specific settings are handled via `appsettings.{Environment}.json` or environment variables.
- Authentication, authorization, and middleware configurations are correctly set up in `Program.cs` or `Startup.cs`.

### 6. Check for Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but have limited or no support in cross-platform .NET. Common areas include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows Registry access or Windows-specific file paths.
- `AppDomain` usage patterns that differ between runtimes.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to surface any remaining compatibility concerns.

### 7. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported framework version.

### 8. Deploy to a Staging Environment

Once local validation is complete, deploy the application to a staging environment that mirrors production. Confirm the following before promoting to production:

- The application starts without errors.
- Database migrations, if applicable, run successfully.
- All critical user flows function as expected under realistic conditions.