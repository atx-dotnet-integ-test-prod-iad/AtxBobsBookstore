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

Review the output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following at runtime:

- The application starts without exceptions.
- Database connectivity works as expected through `Bookstore.Data`.
- Domain logic in `Bookstore.Domain` functions correctly end-to-end.
- All major routes and pages in `Bookstore.Web` are accessible and return expected results.

### 5. Check Target Framework Compatibility

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Manually review the following areas:

- **Configuration**: Ensure `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration` where applicable.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been migrated to Entity Framework Core and that migrations are up to date.
- **HTTP and Web APIs**: Confirm that any `System.Web` dependencies have been fully replaced with ASP.NET Core equivalents.

Run the following command to check for any remaining references to `System.Web` or other incompatible assemblies:

```bash
grep -r "System.Web" app/
```

### 7. Validate Data Layer

If `Bookstore.Data` uses a database, apply and verify migrations:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that the schema is applied correctly and that data access operations work as expected.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.