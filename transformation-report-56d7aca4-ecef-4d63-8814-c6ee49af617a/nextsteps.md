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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Runtime Behavior

Start the web application locally and exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically verify the following areas, as they are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that Entity Framework migrations (if applicable) are up to date. Run `dotnet ef database update` if needed.
- **Configuration**: Ensure that settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` and are being read at runtime.
- **Static files and routing**: Navigate through the application to confirm that pages, assets, and API routes resolve correctly.
- **Authentication and authorization**: If the application uses any authentication middleware, verify that login flows and protected routes behave as expected.

### 5. Check Target Framework Compatibility

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid cross-project compatibility issues.

### 6. Review Removed or Changed APIs

Cross-platform .NET does not include certain APIs that were available in .NET Framework. Use the .NET Upgrade Assistant compatibility analyzer or the following command to surface any remaining compatibility concerns:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to:

- `System.Web` usages, which are not available in cross-platform .NET
- Windows-specific APIs (registry access, Windows identity, etc.)
- Any third-party libraries that may still target .NET Framework only

### 7. Validate Data Layer

If the project uses Entity Framework, confirm the version in use is Entity Framework Core and not the legacy Entity Framework 6 (unless EF6 was intentionally retained). Check the `Bookstore.Data` project references for `Microsoft.EntityFrameworkCore` rather than `EntityFramework`.

## Deployment

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy them to your target hosting environment according to its standard process for cross-platform .NET applications.