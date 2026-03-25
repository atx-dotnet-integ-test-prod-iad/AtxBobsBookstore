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

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output carefully. Any failing tests may indicate behavioral differences introduced during the migration.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target environment.
- If Entity Framework Core is in use, run the following to verify migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any authentication flows, to confirm they behave as expected.

### 6. Review Configuration Files

Check the following files for any values that may still reference legacy .NET Framework-specific settings or paths:

- `appsettings.json`
- `appsettings.Development.json`
- `web.config` (if still present, most settings should now be in `appsettings.json` or `Program.cs`)

Remove or migrate any `<system.web>` or `<appSettings>` entries from `web.config` that are no longer applicable under cross-platform .NET.

### 7. Review Middleware and Startup Configuration

Open `Program.cs` (or `Startup.cs` if still present) and confirm that:

- Middleware is registered in the correct order.
- Authentication and authorization are configured appropriately.
- Static file serving and routing are functioning as expected.

### 8. Check for Platform-Specific API Usage

Run the .NET compatibility analyzer to identify any remaining platform-specific API calls that may not behave correctly on non-Windows systems:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

Address any `CA1416` platform compatibility warnings that appear in the output.