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

Review the output for any warnings that may indicate compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the following areas at a minimum:

- Application startup and home page rendering
- Database connectivity through `Bookstore.Data`
- Domain logic correctness through `Bookstore.Domain`
- Any authentication or authorization flows if present
- CRUD operations related to bookstore entities (e.g., books, authors, orders)

### 5. Check Target Framework Compatibility

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`). Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Pay attention to the following areas:

- **Configuration**: Ensure `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration` if applicable.
- **Entity Framework**: Confirm that any Entity Framework 6 usage has been migrated to Entity Framework Core, or that the correct compatibility package is referenced.
- **HTTP and Web APIs**: Verify that any `System.Web` dependencies have been fully replaced with ASP.NET Core equivalents.
- **File and Registry Access**: Confirm that any Windows-specific APIs (e.g., registry access) have been replaced or removed.

### 7. Review Database Migrations

If `Bookstore.Data` uses Entity Framework Core migrations, verify that the migrations are up to date and apply cleanly against the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Deploy the contents of the `./publish` directory to your target hosting environment, ensuring the runtime environment has the matching .NET version installed.