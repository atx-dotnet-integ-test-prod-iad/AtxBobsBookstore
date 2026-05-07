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

Review the output for any warnings related to package compatibility or version conflicts. Address any packages that may have been targeting the old .NET Framework and verify that their cross-platform equivalents are in use.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings, even if there are no errors. Warnings related to deprecated APIs or nullable reference types may indicate areas that need attention.

### 3. Run Unit Tests

If the solution contains test projects, run all tests to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, verify the following:

- Connection strings in `appsettings.json` are correct and accessible from the new runtime environment.
- Any Entity Framework Core migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add <MigrationName> --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and verify that core pages and functionality load correctly.
- Check the console output for any runtime exceptions or unhandled errors.
- Review any middleware configuration in `Program.cs` or `Startup.cs` to ensure it is compatible with the current version of ASP.NET Core.

### 6. Review Configuration Files

- Confirm that `appsettings.json` and `appsettings.Production.json` contain all required configuration values that may have previously been stored in `Web.config` or `App.config`.
- Verify that any environment-specific settings are correctly separated and that sensitive values are not hardcoded.

### 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but may behave differently or require alternative implementations in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows-specific APIs such as the registry, Windows identity, or COM interop.
- Any third-party libraries that may still target .NET Framework only.

### 8. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application runs correctly from the published output before deploying to the target environment.