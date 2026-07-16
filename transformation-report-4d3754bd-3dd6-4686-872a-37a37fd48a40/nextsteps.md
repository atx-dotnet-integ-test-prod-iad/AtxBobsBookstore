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

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate latent issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

### 4. Verify Runtime Behavior

Launch the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:
- Database connectivity and migrations (if using Entity Framework Core in `Bookstore.Data`)
- Page rendering and routing in `Bookstore.Web`
- Any authentication or session-based features, as these can behave differently between .NET Framework and cross-platform .NET

### 5. Check Entity Framework Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and compatible:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the migrations were originally created under Entity Framework 6 (EF6), they will need to be recreated for Entity Framework Core, as the two are not compatible.

### 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files in `Bookstore.Web`. Confirm that:
- Connection strings are correctly formatted for the target database provider
- Any settings previously stored in `Web.config` or `App.config` have been moved to the appropriate `appsettings.json` entries
- Environment-specific settings (e.g., development vs. production) are separated using `appsettings.Development.json` and `appsettings.Production.json`

### 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.

### 8. Deployment

Once the above steps are completed and the application runs as expected locally, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy them to your target hosting environment according to that environment's standard process (e.g., IIS, Azure App Service, or a Linux server with the ASP.NET Core runtime installed).