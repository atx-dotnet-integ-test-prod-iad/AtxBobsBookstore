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

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` and related ASP.NET types in `Bookstore.Web`
- Any Windows-specific APIs such as the registry or Windows Communication Foundation (WCF)
- Entity Framework version compatibility in `Bookstore.Data`

### 6. Review Configuration Files

Confirm that `web.config` or `app.config` files have been replaced or supplemented with the appropriate `appsettings.json` files. In cross-platform .NET, configuration is typically handled through:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string"
  }
}
```

Verify that `Bookstore.Data` is reading connection strings from the new configuration system.

### 7. Run the Application Locally

Start the application using the .NET CLI:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and verify that core functionality such as browsing, searching, and any data access operations work as expected.

### 8. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework, confirm that migrations are up to date and the database schema is compatible:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of date, create and apply them:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

### 9. Review Logging and Error Handling

Confirm that logging has been updated to use `Microsoft.Extensions.Logging` rather than any legacy logging frameworks that may not be compatible with cross-platform .NET.

### 10. Perform a Final Review of Project References

Verify that the project references between `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` are correctly defined in each `.csproj` file and that no references point to legacy assemblies or GAC-registered components.