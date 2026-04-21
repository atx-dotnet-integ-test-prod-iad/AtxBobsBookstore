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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database and performs read/write operations correctly. Verify that any Entity Framework migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the core business logic exposed by `Bookstore.Domain` through the UI or API endpoints to confirm expected behavior.
- **Web layer**: Navigate through the application pages or API routes in `Bookstore.Web` and verify responses are correct.

### 5. Review Configuration Files

Inspect `appsettings.json` (and any environment-specific variants such as `appsettings.Production.json`) to confirm that:

- Connection strings are correctly formatted for the target database provider.
- Any configuration keys that were previously in `Web.config` or `App.config` have been properly migrated.

### 6. Check for Removed or Changed APIs

Review the code in all three projects for usage of any APIs that behave differently on cross-platform .NET compared to .NET Framework. Common areas to check include:

- `System.Web` references, which are not available on cross-platform .NET and should have been replaced with ASP.NET Core equivalents.
- Windows-specific APIs such as the registry, `System.Drawing` (GDI+), or WCF server-side components.
- Any third-party libraries that may have been targeting .NET Framework only. Verify their NuGet packages have compatible .NET Standard or .NET versions available.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all expected files, static assets, and configuration files are present before deploying to the target environment.