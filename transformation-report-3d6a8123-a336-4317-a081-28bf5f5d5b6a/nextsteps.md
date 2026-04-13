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

Check the output for any warnings that, while non-fatal, may indicate deprecated APIs or patterns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, verify the following:

- **Database Migrations**: If Entity Framework Core is in use, confirm that existing migrations are compatible and apply cleanly:
  ```bash
  dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
  ```
- **Connection Strings**: Confirm that connection strings in `appsettings.json` are correct for your target environment and that no Windows-specific connection string formats are being used.

### 5. Run the Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and test key workflows such as browsing, searching, and any data entry forms to confirm they function as expected.

### 6. Check for Platform-Specific Code

Even without build errors, review the codebase for any remaining platform-specific dependencies that may cause runtime issues on non-Windows environments:

- Use of `System.Drawing` (consider replacing with a cross-platform alternative such as `SkiaSharp` or `ImageSharp` if applicable)
- Windows registry access
- Hardcoded Windows file path separators (`\`); replace with `Path.Combine` or `Path.DirectorySeparatorChar`
- Any P/Invoke calls targeting Windows-only native libraries

### 7. Review Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` to avoid any cross-targeting issues.

### 8. Review Deprecated or Removed APIs

Check for use of any APIs that existed in .NET Framework but have changed behavior or been removed in modern .NET. The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can assist with identifying these if not already used during the transformation.