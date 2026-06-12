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

If no test projects exist, consider writing basic unit tests for the core domain logic in `Bookstore.Domain` before proceeding further.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and functions correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup completes without exceptions
- Database connectivity works as expected (check `Bookstore.Data` configuration)
- Key application routes and pages load correctly
- Any data read/write operations function as intended

### 5. Review Configuration Files

Confirm that configuration files have been correctly migrated:

- `appsettings.json` contains the correct connection strings and application settings
- Any environment-specific settings (e.g., `appsettings.Development.json`) are present and accurate
- Settings previously stored in `Web.config` or `App.config` have been moved to the appropriate `appsettings.json` structure

### 6. Check Target Framework

Open each `.csproj` file and verify the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 7. Validate Database Migrations

If the project uses Entity Framework Core in `Bookstore.Data`, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or outdated, create a new migration to reflect the current model state:

```bash
dotnet ef migrations add PostMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is clean:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all expected files are present before deploying to your target environment.