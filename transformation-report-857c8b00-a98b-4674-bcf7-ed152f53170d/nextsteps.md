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

Review the output for any warnings related to package compatibility or version conflicts, particularly around any packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the build output for any warnings that, while non-blocking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Specifically, verify the following areas which are commonly affected by cross-platform migrations:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly and that Entity Framework (or whichever ORM is in use) migrations and queries execute as expected.
- **File paths**: Ensure any file system operations use `Path.Combine` rather than hardcoded backslash separators, as these will fail on Linux and macOS.
- **Configuration**: Confirm that `appsettings.json` is being read correctly and that any values previously sourced from `Web.config` or `App.config` have been properly migrated.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or any middleware, verify that login, registration, and role-based access work as expected.

### 5. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that behave differently or are unavailable in cross-platform .NET:

- `System.Web` references should no longer be present. If any remain, they will need to be replaced with their `Microsoft.AspNetCore` equivalents.
- `BinaryFormatter` is disabled by default in modern .NET. If serialization is used, migrate to a supported alternative such as `System.Text.Json` or `System.Xml.Serialization`.
- `AppDomain`, `Thread.Abort`, and reflection-based APIs may behave differently and should be reviewed.

### 6. Database Migrations

If Entity Framework Core is in use, verify that the migration history is intact and apply any pending migrations against your target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.