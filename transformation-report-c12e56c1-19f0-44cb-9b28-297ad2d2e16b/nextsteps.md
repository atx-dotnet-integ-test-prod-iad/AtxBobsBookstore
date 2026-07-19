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

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent compilation.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- Application startup without exceptions
- Database connectivity through `Bookstore.Data`
- Domain logic execution through `Bookstore.Domain`
- All major routes and pages in `Bookstore.Web` load without errors

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Manually review the following areas:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET
- `HttpContext` and related types, which should now come from `Microsoft.AspNetCore.Http`
- Configuration access patterns, which should use `Microsoft.Extensions.Configuration` rather than `System.Configuration.ConfigurationManager`
- Any Windows-specific APIs such as the registry, WMI, or Windows identity classes

### 7. Review Database Migrations

If the project uses Entity Framework, verify that existing migrations are compatible with the updated version of EF Core:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

If migrations are missing or inconsistent, consider generating a new initial migration against the current model.

### 8. Check NuGet Package Compatibility

Review the NuGet packages referenced across all projects and confirm they support the target framework. Packages that were built for .NET Framework only may require replacement with actively maintained alternatives. The [NuGet compatibility tab](https://www.nuget.org/packages) can be used to verify framework support for each package.