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

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not cause build failures.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing integration or unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data`.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations or database connection strings are correctly configured for the new runtime. Check the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are valid.
- If using Entity Framework Core, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

### 7. Review Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but may behave differently or require alternatives in cross-platform .NET. Common areas to check include:

- `System.Web` references (should have been removed or replaced).
- Windows Registry access.
- File path separators (use `Path.Combine` rather than hardcoded backslashes).
- `ConfigurationManager` usage (should be replaced with `Microsoft.Extensions.Configuration`).

### 8. Review Warnings

Even with a clean build, run the build with detailed verbosity to surface any suppressed warnings:

```bash
dotnet build --verbosity detailed 2>&1 | grep -i warning
```

Address any warnings related to obsolete APIs or nullable reference types as appropriate.