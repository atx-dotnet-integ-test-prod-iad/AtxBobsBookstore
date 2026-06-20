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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects are still referencing `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific APIs

Even without build errors, runtime failures can occur if the code uses Windows-specific APIs. Run the .NET Compatibility Analyzer if it is not already included:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any analyzer warnings that surface in the build output.

### 5. Run Existing Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

### 6. Run the Web Application Locally

Start the web application and verify basic functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry features, to confirm runtime behavior is correct.

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that any migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of sync, generate a new migration and apply it to a development database:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Test on a Non-Windows Platform

Since the goal of the transformation is cross-platform support, validate the application runs correctly on Linux or macOS if those are target environments. Pay particular attention to:

- File path separators
- Case-sensitive file system behavior
- Any configuration or static file references that may have been written with Windows paths