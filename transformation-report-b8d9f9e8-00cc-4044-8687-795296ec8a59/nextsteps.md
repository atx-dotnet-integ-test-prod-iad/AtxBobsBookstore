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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup completes without exceptions
- Database connectivity is functional (if `Bookstore.Data` uses Entity Framework or another ORM, confirm migrations are applied and queries execute correctly)
- Core domain logic in `Bookstore.Domain` behaves as expected through the UI or API endpoints

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Review any use of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` and related types, which have moved to `Microsoft.AspNetCore.Http`
- Any Windows-specific APIs that may not function on Linux or macOS

### 7. Review Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all configuration values that were previously stored in `Web.config` or `App.config`. Verify connection strings and application settings are correct.

### 8. Database Migration Check

If the project uses Entity Framework Core, verify that all migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 9. Publish the Application

Once the above steps are completed and the application behaves correctly, publish the application to the target environment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy them to the target server or hosting environment according to your infrastructure requirements.