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

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to validate core logic:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Production.json` are updated to reflect the target environment.
- If Entity Framework Core is in use, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database schema is created or updated as expected.

### 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application URL (typically `https://localhost:5001` or `http://localhost:5000`).
- Exercise the primary workflows such as browsing, searching, and any data entry features to confirm they function as expected.

### 6. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` value is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues.

### 7. Review Removed or Changed APIs

Check for any use of APIs that were available in .NET Framework but have changed or been removed in modern .NET, including:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore` equivalents)
- `HttpContext` usage patterns
- Any Windows-specific APIs if cross-platform support is required

### 8. Check Configuration Migration

Confirm that configuration previously held in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application settings keys
- Any custom configuration sections

### 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.