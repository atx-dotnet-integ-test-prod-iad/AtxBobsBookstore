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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors are reported during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Start the web application locally and perform manual smoke testing on critical workflows such as browsing, searching, and any data access operations:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Pay particular attention to:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the expected database and that migrations, if any, apply correctly.
- **Configuration loading**: Verify that `appsettings.json` or environment-specific configuration files are being read correctly, as the configuration system differs between .NET Framework and modern .NET.
- **Static assets**: Confirm that CSS, JavaScript, and image files are served correctly.
- **Authentication and authorization**: If the application uses any authentication middleware, verify that it initializes and functions correctly under the new runtime.

### 5. Review Target Framework Compatibility

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended modern .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid interoperability issues.

### 6. Review Removed or Changed APIs

Check the code in each project for any use of APIs that were removed or significantly changed in modern .NET. Common areas to review include:

- `System.Web` references, which are not available in modern .NET and should have been replaced with `Microsoft.AspNetCore` equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usage patterns.
- Any use of `ConfigurationManager`, which should be replaced with `Microsoft.Extensions.Configuration`.
- Entity Framework version compatibility if `Bookstore.Data` uses Entity Framework, confirming whether it has been migrated to Entity Framework Core.

### 7. Publish the Application

Once runtime validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present before deploying to the target environment.