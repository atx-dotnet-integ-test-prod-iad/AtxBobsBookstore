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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without errors or warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral regressions introduced during the transformation.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following areas at a minimum:

- Application startup and home page load
- Database connectivity through `Bookstore.Data` (check connection strings in `appsettings.json`)
- Core domain operations such as browsing, searching, or managing books depending on the application's feature set
- Any authentication or authorization flows if present

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application settings. Confirm that:

- All connection strings and application settings have been moved to `appsettings.json` or `appsettings.{Environment}.json`
- Any environment-specific configuration is correctly structured for the `IConfiguration` system
- Sensitive values are not hardcoded and are handled via environment variables or user secrets where appropriate

### 6. Check Entity Framework Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are in a valid state:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project was previously using Entity Framework 6, ensure it has been migrated to Entity Framework Core and that the existing migrations or database schema are compatible.

### 7. Review Static Files and Middleware

Confirm that static files (CSS, JavaScript, images) are located in the `wwwroot` folder and that the middleware pipeline in `Program.cs` or `Startup.cs` includes:

- `app.UseStaticFiles()`
- `app.UseRouting()`
- Any other middleware previously configured in `Global.asax` or `Startup.cs` from the legacy project

### 8. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to ensure all required files are present before deploying to the target environment.