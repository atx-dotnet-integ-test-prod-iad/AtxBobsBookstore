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

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output carefully. Any failing tests should be investigated to determine whether the failure is due to the migration or a pre-existing issue.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, confirm the following areas function as expected:

- **Database connectivity**: Ensure `Bookstore.Data` can connect to and query the database. Verify that any Entity Framework migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Confirm that business rules in `Bookstore.Domain` behave correctly at runtime.
- **Web layer**: Navigate through the application pages and verify that routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) to ensure:

- Connection strings are correct for the target environment.
- Any configuration keys previously stored in `Web.config` have been properly migrated to the new configuration system.

### 6. Check Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended .NET version (for example, `net8.0`). Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is as expected:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assemblies, static assets, and configuration files are present before deploying to the target environment.