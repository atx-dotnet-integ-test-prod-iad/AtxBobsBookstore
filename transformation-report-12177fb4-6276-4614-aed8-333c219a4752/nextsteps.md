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

Perform a full solution build to confirm the absence of any compile-time errors:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core or data access configuration is functioning correctly:

- Check that the connection strings in `appsettings.json` (or equivalent) are valid and point to the correct database.
- If Entity Framework Core is in use, run the following to verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If there are pending migrations, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the URL indicated in the console output.
- Verify that the application loads without runtime errors.
- Test core functionality such as browsing, searching, and any data-driven pages to confirm that `Bookstore.Domain` and `Bookstore.Data` are integrating correctly with `Bookstore.Web`.

### 6. Review Target Framework

Open each `.csproj` file and confirm that the `TargetFramework` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid compatibility issues.

### 7. Review Removed Windows-Specific APIs

Check the codebase for any APIs that were previously available in .NET Framework but may have changed behavior in cross-platform .NET, including:

- `System.Web` references (these are not available in cross-platform .NET)
- `HttpContext` usage outside of the ASP.NET Core request pipeline
- Any registry, COM interop, or Windows-specific I/O calls

Address any such usages by replacing them with their cross-platform equivalents.

### 8. Check Runtime Behavior on Target Platform

If the intended deployment platform is Linux or macOS, run the application on that platform specifically to catch any remaining platform-specific issues such as:

- File path casing sensitivity
- Platform-specific line endings in file processing logic
- Differences in default encoding behavior