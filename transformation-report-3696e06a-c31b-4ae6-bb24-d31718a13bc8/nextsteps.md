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

Review the output for any warnings related to deprecated packages or version conflicts that may not surface as build errors but could cause runtime issues.

### 2. Build the Solution

Perform a full solution build to confirm the clean state:

```bash
dotnet build --configuration Release
```

Verify that the output confirms zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Pay close attention to any tests that exercise data access logic in `Bookstore.Data` or domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by framework differences.

### 4. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent).
- Any existing migrations are compatible with EF Core. Run the following to check the current migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or inconsistent, consider creating a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Check Configuration Files

Review `appsettings.json` in `Bookstore.Web` to confirm the following:

- Connection strings are correctly defined and point to the intended database.
- Any configuration keys that were previously in `Web.config` have been properly moved to `appsettings.json` or `appsettings.{Environment}.json`.

### 6. Run the Application Locally

Start the application and verify basic functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and test core workflows such as browsing, searching, and any data entry forms to confirm end-to-end functionality is intact.

### 7. Review Target Framework Compatibility

Open each `.csproj` file and confirm the `TargetFramework` value is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Also check that no projects still reference `net48` or `netcoreapp3.x` unless intentional.

### 8. Check for Windows-Specific APIs

If cross-platform support is a goal, scan the codebase for any remaining Windows-specific dependencies such as:

- `System.Web` references
- Windows registry access
- Windows-only file path assumptions

These will not always produce build errors on Windows but will fail at runtime on Linux or macOS.