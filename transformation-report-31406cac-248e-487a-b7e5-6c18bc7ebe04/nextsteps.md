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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the clean state:

```bash
dotnet build --configuration Release
```

Verify that the output reports zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to your intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target framework version.
- Connection strings in configuration files (`appsettings.json`) are correct and accessible in the new environment.
- Run any pending Entity Framework Core migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- Application starts without runtime exceptions.
- Key pages and routes load correctly.
- Data is read from and written to the database as expected.
- Static assets (CSS, JavaScript, images) are served correctly.

### 7. Check for Windows-Specific API Usage

Even without build errors, runtime issues can arise from Windows-specific APIs that compile successfully but fail on other platforms. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet build /p:PlatformTarget=AnyCPU
```

Additionally, review any use of `System.Web`, Windows registry access, or Windows-only file path assumptions.

### 8. Review Configuration and Middleware

In `Bookstore.Web`, confirm that the application startup has been properly migrated from the legacy `Global.asax` / `Web.config` pattern to the modern `Program.cs` and `appsettings.json` pattern. Verify that:

- Middleware is registered in the correct order.
- Authentication and authorization configuration is present if applicable.
- Environment-specific configuration (Development, Production) is functioning correctly.