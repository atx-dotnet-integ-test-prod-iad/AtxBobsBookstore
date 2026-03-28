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

Verify that no warnings or errors appear during the restore process. Pay attention to any packages that may have been replaced with newer cross-platform equivalents during the transformation, as behavior differences can sometimes exist between package versions.

### 2. Build the Solution

Perform a full solution build to confirm the error-free state holds under a clean build:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while not blocking, may indicate deprecated APIs or compatibility concerns that should be addressed before deployment.

### 3. Run Unit Tests

If the solution contains test projects, execute them now:

```bash
dotnet test
```

If no test projects currently exist, it is worth adding unit tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` to establish a baseline before deploying.

### 4. Verify Data Layer Behavior

Since `Bookstore.Data` handles data access, confirm the following:

- Database connection strings in configuration files (e.g., `appsettings.json`) are correct for the target environment.
- Any Entity Framework migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If the project previously used `App.config` or `Web.config` for connection strings, verify these have been migrated to `appsettings.json` properly.

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the local URL provided in the console output and manually verify that core pages and features load correctly, including any pages that interact with the database through `Bookstore.Data` and `Bookstore.Domain`.

### 6. Review Configuration Files

Check the following in `Bookstore.Web`:

- `appsettings.json` and `appsettings.Production.json` contain the correct environment-specific values.
- Any middleware or service registrations in `Program.cs` or `Startup.cs` are complete and reflect what was previously configured in the legacy project.
- Static files, bundling, and any view-related assets render correctly in the browser.

### 7. Target Framework Verification

Confirm each project is targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 8. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target hosting environment and verify the application starts and operates correctly there. Confirm that the production database connection string and any environment-specific configuration values are set correctly on the target server.