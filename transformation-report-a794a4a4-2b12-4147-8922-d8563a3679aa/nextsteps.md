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

Review the output for any warnings related to package compatibility or version conflicts.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, deprecated APIs, or target framework compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output carefully. Any failing tests may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Data Layer (`Bookstore.Data`)

- Confirm that the database provider (e.g., Entity Framework Core) is configured correctly for the target platform.
- Check that any connection strings in configuration files (`appsettings.json`) are valid and appropriate for the target environment.
- If using EF Core migrations, verify the migration history is intact and apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser.
- Test key user flows such as browsing, searching, and any data entry forms.
- Check the console and application logs for runtime exceptions or warnings.

### 6. Review Configuration Files

- Ensure `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) contain the correct values for the new environment.
- Confirm that any file paths, which may have been Windows-specific in the legacy project, have been updated to use cross-platform path handling (e.g., `Path.Combine` rather than hardcoded backslashes).

### 7. Check Static Assets and Views

- Verify that all static files (CSS, JavaScript, images) are served correctly.
- If the project uses Razor views or Razor Pages, confirm they render without errors.

### 8. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.