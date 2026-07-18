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

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- Connection strings in `appsettings.json` or `appsettings.Production.json` are updated to reflect the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output and verify that the application loads and core functionality works correctly, including any pages that interact with the data layer.

### 6. Review Configuration Files

Check the following configuration concerns that are common after a migration to cross-platform .NET:

- **`web.config`**: This file is no longer the primary configuration mechanism. Confirm that all relevant settings have been moved to `appsettings.json`.
- **Static files and wwwroot**: Verify that static assets are placed under the `wwwroot` folder and are being served correctly.
- **Authentication/Authorization**: If the application uses Windows Authentication or any legacy ASP.NET membership providers, confirm these have been replaced with ASP.NET Core compatible equivalents.
- **HTTP Modules and Handlers**: These do not exist in ASP.NET Core. Confirm they have been replaced with the appropriate middleware in `Program.cs` or `Startup.cs`.

### 7. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to a currently supported version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If an older version such as `net6.0` is present, consider updating to `net8.0` to align with the current Long-Term Support release.

### 8. Review Deprecated or Removed APIs

Search the codebase for any APIs that were available in .NET Framework but have changed or been removed in modern .NET. The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can assist with identifying these issues if any surface during runtime testing.