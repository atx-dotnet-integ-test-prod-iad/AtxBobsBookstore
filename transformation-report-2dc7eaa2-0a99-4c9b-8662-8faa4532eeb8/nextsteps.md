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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-breaking, may indicate compatibility concerns with the new target framework.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Inspect each project's `.csproj` for any NuGet packages or references that are Windows-specific. Common examples include:

- `Microsoft.Web.Infrastructure`
- `System.Web` (not available in cross-platform .NET)
- Any package with a `windows` target framework condition

If any are found, identify cross-platform alternatives or conditionally target them only on Windows using `<TargetFramework>net8.0-windows</TargetFramework>` if absolutely necessary.

### 5. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are caused by the migration or pre-existing issues.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs correctly on the local development machine:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows.
- Check the console output and application logs for any runtime exceptions.
- Verify database connectivity if `Bookstore.Data` uses Entity Framework or another ORM, and confirm that migrations are up to date:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Validate Configuration Files

Review `appsettings.json` (and any environment-specific variants such as `appsettings.Production.json`) to confirm that:

- Connection strings are correct for the target environment.
- Any configuration keys previously stored in `Web.config` have been properly migrated to the `appsettings.json` structure.
- Secrets are not stored in plain text; consider using the .NET Secret Manager or environment variables.

### 8. Cross-Platform Smoke Test

If one of the goals of the migration is to run on a non-Windows operating system, run the application on the target OS (Linux or macOS) to identify any remaining platform-specific issues such as:

- File path separator assumptions (`\` vs `/`)
- Windows registry access
- Windows-only authentication schemes (e.g., NTLM/Windows Authentication)