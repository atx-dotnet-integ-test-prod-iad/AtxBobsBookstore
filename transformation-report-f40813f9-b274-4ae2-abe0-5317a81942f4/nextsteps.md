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

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types or obsolete APIs, as these may indicate areas that need attention even if they do not prevent compilation.

### 3. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test
```

Review test results to confirm that existing business logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` behaves as expected after the migration.

### 4. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The connection string in `appsettings.json` is correctly configured for your target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the application and verify it runs correctly on the cross-platform runtime:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any authentication flows, to confirm functional correctness.

### 6. Review Configuration Files

- Confirm that `appsettings.json` and `appsettings.Development.json` contain all necessary configuration values that may have previously been stored in `Web.config` or `App.config`.
- Check that any environment-specific settings are correctly separated and not hardcoded.

### 7. Check for Platform-Specific Code

Review the codebase for any remaining usage of Windows-specific APIs that may not be available on Linux or macOS, such as:

- `System.Drawing` (GDI+)
- Windows Registry access
- Windows-only authentication providers

Replace or wrap these with cross-platform alternatives where necessary.

### 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported framework version.