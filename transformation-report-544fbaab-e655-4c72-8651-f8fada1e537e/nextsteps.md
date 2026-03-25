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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new runtime.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another ORM, confirm the following:

- The connection string in `appsettings.json` is valid for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- EF Core tooling is installed if not already:

```bash
dotnet tool install --global dotnet-ef
```

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm end-to-end functionality.

### 7. Review `System.Web` and Windows-Specific API Usage

Search the codebase for any remaining references to `System.Web` or other Windows-specific APIs that may have been carried over but could fail at runtime on non-Windows platforms:

```bash
grep -r "System.Web" ./app
```

Replace or remove any such references using the appropriate ASP.NET Core equivalents.

### 8. Check Configuration Migration

Confirm that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` and are being read via `IConfiguration` in the ASP.NET Core pipeline.

### 9. Review Middleware and Startup Configuration

Inspect `Program.cs` (and `Startup.cs` if present) to ensure that all required middleware is registered, including:

- Routing
- Authentication and Authorization (if applicable)
- Static files
- Database context registration

### 10. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal of the transformation is cross-platform compatibility, consider running the application on Linux or macOS to surface any remaining platform-specific issues:

```bash
dotnet run --project Bookstore.Web
```