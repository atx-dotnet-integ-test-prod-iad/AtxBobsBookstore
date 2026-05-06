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

Confirm that all three projects build without warnings or errors before proceeding.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic has not been broken during the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Areas to verify include:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. Check your connection strings in `appsettings.json` and ensure they are appropriate for the target environment.
- **Entity Framework migrations**: If the project uses Entity Framework, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the primary workflows of the application (e.g., browsing, searching, and purchasing books) to confirm that `Bookstore.Domain` behaves as expected.
- **Static assets and routing**: Confirm that all pages render correctly and that static files (CSS, JavaScript, images) are served properly.

### 5. Review Configuration Files

Compare the new `appsettings.json` with any legacy `Web.config` or `App.config` files to ensure all configuration values were carried over, including:

- Connection strings
- Application settings
- Logging configuration
- Authentication or authorization settings

### 6. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that were available in .NET Framework but may behave differently or require alternatives in cross-platform .NET:

- `System.Web` references (should have been replaced)
- Windows-specific APIs (e.g., registry access, Windows authentication)
- Any third-party libraries that may not have cross-platform NuGet equivalents

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 8. Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy them to your target environment according to your hosting setup (e.g., IIS, Kestrel behind a reverse proxy, or a Linux server).