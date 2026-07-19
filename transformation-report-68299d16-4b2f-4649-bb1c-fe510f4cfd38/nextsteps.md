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

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the key areas of the application, including:

- Browsing and searching for books
- Any data access operations driven by `Bookstore.Data`
- Any domain logic driven by `Bookstore.Domain`

### 5. Check Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended modern .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 6. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Check the following areas manually:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET
- `HttpContext` usage patterns, which may need to be updated to use the ASP.NET Core equivalents
- Any configuration code that previously relied on `Web.config`, which should now use `appsettings.json` and the `IConfiguration` system
- Any database connection strings or Entity Framework configuration that may need to be updated for the new provider model

### 7. Review Data Layer Compatibility

In `Bookstore.Data`, verify that the data access technology in use is compatible with the target framework:

- If using Entity Framework, confirm it has been migrated to **Entity Framework Core**
- Run any pending migrations or verify the database schema is aligned with the current model:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Deploy the contents of the `./publish` directory to your target hosting environment, ensuring the correct .NET runtime version is installed on the host.