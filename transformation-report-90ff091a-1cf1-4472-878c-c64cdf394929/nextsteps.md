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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure all three projects are targeting a consistent framework version.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one to cover critical paths in `Bookstore.Domain` and `Bookstore.Data`.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any database connection strings and Entity Framework (or other ORM) configurations are compatible with the new runtime. Check the following:

- Connection strings in `appsettings.json` are correct for the target environment.
- Any Entity Framework migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 6. Run the Web Application Locally

Start the web application to confirm it runs correctly end-to-end:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify that core functionality such as page rendering, data retrieval, and form submissions work as expected.

### 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or dependencies that may not have been flagged as build errors but could cause runtime failures on non-Windows platforms. Common areas to inspect include:

- File path handling (use `Path.Combine` rather than hardcoded separators).
- Registry access or Windows-specific authentication mechanisms.
- Any use of `System.Windows` or `Microsoft.Win32` namespaces.

### 8. Review Middleware and Configuration

In `Bookstore.Web`, review `Program.cs` or `Startup.cs` to ensure middleware configuration follows current .NET conventions. Confirm that any legacy `HttpModule` or `HttpHandler` patterns have been replaced with the appropriate ASP.NET Core middleware equivalents.

### 9. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server or hosting environment and verify the application starts correctly in that environment.