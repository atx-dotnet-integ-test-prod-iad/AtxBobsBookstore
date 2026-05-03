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

Run the following command from the root of the solution to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while not blocking, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework), confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or the appropriate provider for your database).
- Any existing migrations are compatible with EF Core. If they were generated under EF 6, they will need to be regenerated:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Connection strings in `appsettings.json` are correctly configured.

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test primary workflows such as browsing, searching, and any authentication flows if present.

### 6. Review Configuration Migration

Legacy .NET Framework projects used `Web.config` and `App.config`. Confirm that all relevant configuration values have been moved to `appsettings.json` or environment variables, including:

- Connection strings
- Application settings
- Any custom configuration sections

### 7. Check for Runtime-Only Issues

Some issues do not surface at build time but appear at runtime. Pay particular attention to:

- Reflection-based code that may behave differently under .NET
- Any use of `System.Web` APIs that may have been replaced with ASP.NET Core equivalents
- HTTP module or HTTP handler logic that should now be implemented as ASP.NET Core middleware

### 8. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to an actively supported version, such as `net8.0`:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If an older version such as `net6.0` is present, consider upgrading to a long-term support (LTS) release.