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

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether the failures are due to the migration or pre-existing issues.

### 4. Verify Data Layer Behavior

Since `Bookstore.Data` handles data access, confirm the following:

- Database connection strings in configuration files (e.g., `appsettings.json`) are correct and accessible from the new environment.
- Any Entity Framework migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be applied to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that core functionality such as browsing, searching, and any data-driven features behave as expected.

### 6. Review Configuration Files

Check `appsettings.json` and `appsettings.Development.json` for any settings that may have been carried over from the legacy project and are no longer valid or applicable in cross-platform .NET, such as:

- Windows-specific paths
- Legacy authentication or session configurations
- Any references to `System.Web` or classic ASP.NET settings

### 7. Check for Platform-Specific API Usage

Run the .NET compatibility analyzer to identify any remaining platform-specific API calls that may not behave correctly on non-Windows environments:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Review and address any `CA1416` (platform compatibility) warnings that are produced.

### 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.