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

Review the output for any warnings that may indicate compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise its core features:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas in particular:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Validate that the business rules in `Bookstore.Domain` produce the same results as the legacy application.
- **Web layer**: Navigate through the application's pages or API endpoints and confirm responses are correct.

### 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings have been moved to `appsettings.json` or an equivalent configuration source.
- Any environment-specific settings are handled using `appsettings.{Environment}.json` files or environment variables.
- Authentication, authorization, and middleware configurations in `Bookstore.Web` are correctly set up for ASP.NET Core conventions.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs behave differently or are unavailable on non-Windows platforms. Review the codebase for usage of the following:

- `System.Drawing` (GDI+ is not fully supported cross-platform; consider `SkiaSharp` or `ImageSharp` as alternatives)
- Windows Registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `System.Web` types that may have been shimmed during transformation

Use the .NET Compatibility Analyzer to surface any remaining concerns:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

### 7. Target Framework Confirmation

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same major version to avoid inter-project compatibility issues.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify that all required assets, views, and static files are present before deploying to the target environment.