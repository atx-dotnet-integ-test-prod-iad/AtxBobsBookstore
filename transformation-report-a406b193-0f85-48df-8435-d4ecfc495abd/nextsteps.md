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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate compatibility concerns introduced during migration.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review the test output carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new target framework.

### 4. Verify Runtime Behavior

Launch the `Bookstore.Web` project locally and manually exercise the core application flows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly and that any Entity Framework migrations are up to date. Run pending migrations if necessary:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- **Domain logic**: Confirm that business rules in `Bookstore.Domain` produce the same results as the legacy application.
- **Web layer**: Verify that all routes, views, and API endpoints respond correctly, including authentication and authorization flows if applicable.

### 5. Review Configuration Files

Cross-platform .NET handles configuration differently from legacy .NET Framework projects. Verify the following:

- `appsettings.json` contains all settings that were previously in `Web.config` or `App.config`.
- Connection strings are correctly defined and accessible at runtime.
- Any environment-specific settings are placed in `appsettings.Development.json` or equivalent environment-specific files.

### 6. Check for Platform-Specific Code

Even without build errors, there may be runtime issues caused by code that relied on Windows-specific behavior. Review the codebase for:

- File path separators (use `Path.Combine` rather than hardcoded `\` characters).
- Registry access or Windows-specific APIs that do not exist on Linux or macOS.
- Any use of `System.Web` types that may have been shimmed during transformation but could behave differently at runtime.

### 7. Review Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file and verifying the `<TargetFramework>` element is consistent across the solution and aligned with your intended support requirements.