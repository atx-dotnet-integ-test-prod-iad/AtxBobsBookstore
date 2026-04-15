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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent compilation.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test
```

Review test results for any failures that may have been introduced by the migration, such as behavioral differences between .NET Framework and cross-platform .NET.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database and that any Entity Framework migrations are up to date. Run pending migrations if necessary:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Configuration**: Verify that `appsettings.json` contains all required configuration values that may have previously existed in `Web.config` or `App.config`.
- **Static assets and routing**: Navigate through the application in a browser and confirm that pages, routes, and static files resolve correctly.
- **Authentication and authorization**: If the application uses any authentication middleware, verify that login and access control function as expected.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 6. Check for Removed or Changed APIs

Review any use of APIs that behave differently on cross-platform .NET compared to .NET Framework. Common areas to inspect include:

- `System.Web` references, which are not available in cross-platform .NET and should have been replaced with ASP.NET Core equivalents.
- Windows-specific APIs such as the registry, certain cryptography providers, or WCF server-side components.
- Any third-party libraries that may still target .NET Framework only.

### 7. Publish the Application

Once runtime behavior is confirmed, publish the application to verify the output is complete:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all expected files, including configuration files and static assets, are present.