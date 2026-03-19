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

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types or obsolete APIs, as these may indicate areas that need attention even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas in particular:

- Database connectivity and data access through `Bookstore.Data`
- Domain logic behavior in `Bookstore.Domain`
- All web routes and pages in `Bookstore.Web` render and function as expected
- Any authentication or authorization flows still operate correctly

### 5. Check Entity Framework Migrations (If Applicable)

If `Bookstore.Data` uses Entity Framework, verify that migrations are compatible with the new target framework:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database schema needs to be updated, apply pending migrations to a test database before touching any production data:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 6. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) have been migrated correctly. Legacy `Web.config` or `App.config` settings should now be represented in the appropriate JSON configuration files.

### 7. Target Framework Confirmation

Open each `.csproj` file and confirm the `<TargetFramework>` element reflects the intended cross-platform .NET version (e.g., `net8.0`):

- `app/Bookstore.Domain/Bookstore.Domain.csproj`
- `app/Bookstore.Data/Bookstore.Data.csproj`
- `app/Bookstore.Web/Bookstore.Web.csproj`

### 8. Publishing the Application

Once validation is complete, publish the application using the following command, adjusting the runtime identifier as needed for your target platform:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and configuration files are present before deploying to the target environment.