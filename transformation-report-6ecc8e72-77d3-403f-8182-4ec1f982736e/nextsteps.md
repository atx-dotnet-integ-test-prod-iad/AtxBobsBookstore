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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while non-fatal, may indicate deprecated APIs or compatibility concerns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new target framework or by pre-existing issues.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas, as they are common sources of runtime issues after migration even when the build succeeds:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that any Entity Framework migrations are up to date. Run `dotnet ef database update` if applicable.
- **Configuration**: Check that `appsettings.json` contains all required configuration values that may have previously been stored in `Web.config` or `App.config`.
- **Static files and routing**: Confirm that pages load correctly and that routing behaves as expected under ASP.NET Core conventions.
- **Authentication and authorization**: If the application uses any auth middleware, verify that it initializes and functions correctly.

### 5. Review Target Framework Compatibility

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`). Also check for any remaining references to `net4x` or `netstandard` that may indicate an incomplete migration.

### 6. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Review the following:

- Any use of `System.Web` namespaces, which are not available in .NET Core or later.
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core.
- Any reflection-based or serialization code that may be affected by changes in `System.Text.Json` versus `Newtonsoft.Json`.

### 7. Review Warnings as Potential Issues

Run the build with detailed output to surface any warnings that may indicate future problems:

```bash
dotnet build --configuration Release --verbosity detailed 2>&1 | grep -i warning
```

Address nullable reference warnings, obsolete API usage, and any platform compatibility warnings before deploying to production.

## Deployment

Once the application has been validated locally:

1. Publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

2. Confirm the contents of the `./publish` directory include all expected assemblies, static assets, and configuration files.
3. Deploy the contents of the `./publish` directory to your target hosting environment, ensuring the correct .NET runtime version is installed on the host.