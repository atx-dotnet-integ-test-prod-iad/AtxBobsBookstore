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

Review the output for any warnings that may indicate compatibility issues, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the key areas of the application, including:

- Browsing and searching for books
- Any data access operations driven by `Bookstore.Data`
- Any domain logic driven by `Bookstore.Domain`

### 5. Check Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm the chosen version is still actively supported.

### 6. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Review the following areas for potential runtime issues:

- **Configuration**: Ensure `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration` if applicable.
- **Entity Framework**: Confirm the project has migrated from Entity Framework 6 to Entity Framework Core if data access is involved, and that all migrations are up to date.
- **HTTP and Web APIs**: Verify that any `System.Web` dependencies have been fully replaced with ASP.NET Core equivalents.

Run the following command to check for any remaining compatibility concerns using the .NET Upgrade Assistant or API analyzer:

```bash
dotnet tool install -g dotnet-apicompat
```

### 7. Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that the database schema is in sync:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to your target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Application Logs

After running the application, review the application logs for any runtime exceptions or deprecation warnings that would not surface at build time.