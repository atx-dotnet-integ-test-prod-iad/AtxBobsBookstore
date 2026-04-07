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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they are not hard errors. Pay particular attention to:

- Deprecated API usage warnings
- Nullable reference type warnings
- Platform compatibility warnings (e.g., `CA1416`)

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to specifically validate:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the key business logic paths exposed by `Bookstore.Domain` to confirm consistent behavior.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Cross-platform .NET does not use `Web.config` or `App.config` in the same way as .NET Framework. Confirm that:

- `appsettings.json` (and `appsettings.{Environment}.json`) contains all necessary configuration values that were previously in `Web.config`.
- Connection strings have been correctly migrated to `appsettings.json` or environment variables.
- Any configuration transforms that previously relied on `Web.config` transforms have been replaced with the appropriate .NET configuration provider approach.

### 6. Check for Windows-Specific Dependencies

Since this is now a cross-platform project, review the code for any remaining Windows-specific APIs or libraries, particularly in `Bookstore.Data` and `Bookstore.Web`. Common areas to check include:

- Windows Registry access
- Windows Authentication configuration
- File path separators (use `Path.Combine` rather than hardcoded backslashes)
- Any P/Invoke calls targeting Windows-only system libraries

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same major version to avoid inter-project compatibility issues.

## Deployment

Once all validation steps above pass:

1. Publish the web application using:
   ```bash
   dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
   ```
2. Verify the contents of the `./publish` directory contain all expected assemblies and static assets.
3. Deploy the contents of the `./publish` directory to your target hosting environment (IIS, Linux server, Azure App Service, etc.).
4. If deploying to IIS, ensure the ASP.NET Core Hosting Bundle is installed on the server and that the application pool is set to **No Managed Code**.