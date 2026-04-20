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

Verify that all three projects build without warnings or errors.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas in particular:

- Database connectivity and data access through `Bookstore.Data`
- Domain logic correctness in `Bookstore.Domain`
- Page rendering, routing, and form submissions in `Bookstore.Web`

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm that:

- Connection strings are valid and point to the correct database
- Any settings previously stored in `Web.config` or `App.config` have been correctly migrated to the new configuration system

### 6. Check Entity Framework Migrations (If Applicable)

If the project uses Entity Framework, verify that migrations are intact and the database schema is up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element references the intended .NET version (for example, `net8.0`). Ensure consistency across all three projects.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to your target environment.