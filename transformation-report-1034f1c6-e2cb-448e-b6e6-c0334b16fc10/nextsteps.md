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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless intentionally required.

### 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining dependencies that are Windows-specific, such as:

- `System.Web` references
- Windows Registry access
- COM interop components
- `Microsoft.Web.*` packages that do not support cross-platform scenarios

Run the .NET Upgrade Assistant compatibility analyzer if any uncertainty remains:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze
```

### 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether failures are caused by the migration or pre-existing issues.

### 6. Verify Runtime Behavior

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically verify:

- Database connectivity through `Bookstore.Data`
- Domain logic correctness through `Bookstore.Domain`
- All major web routes and pages load without errors
- Any authentication or authorization flows behave as expected

### 7. Review Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) contain all configuration values that were previously held in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Application settings keys
- Logging configuration

### 8. Validate Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct EF Core version is referenced and run a check against the database:

```bash
dotnet ef dbcontext info --project app/Bookstore.Data/Bookstore.Data.csproj
```

If migrations are used, verify they are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```