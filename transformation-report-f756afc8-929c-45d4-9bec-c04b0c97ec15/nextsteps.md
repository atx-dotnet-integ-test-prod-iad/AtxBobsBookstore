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

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime.

### 5. Run the Application Locally

Start the `Bookstore.Web` project locally to verify that the application runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connectivity through `Bookstore.Data` is functioning (check connection strings for any Windows-specific configurations such as Integrated Security that may not work cross-platform).
- Core domain logic in `Bookstore.Domain` behaves as expected through the UI or API endpoints.

### 6. Check for Windows-Specific Dependencies

Even without build errors, runtime issues can arise from Windows-specific APIs. Review the codebase for usage of:

- `Microsoft.Win32` namespaces
- Windows registry access
- Windows-specific file path assumptions (e.g., backslashes)
- `System.Drawing` (GDI+), which has limited cross-platform support

Replace or abstract any such dependencies as needed.

### 7. Verify Database Migrations

If the project uses Entity Framework Core, confirm that existing migrations are compatible and that the database can be updated:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Ensure that `appsettings.json` and any environment-specific configuration files are properly structured for the new hosting model. Confirm that any settings previously stored in `Web.config` have been migrated to `appsettings.json`.