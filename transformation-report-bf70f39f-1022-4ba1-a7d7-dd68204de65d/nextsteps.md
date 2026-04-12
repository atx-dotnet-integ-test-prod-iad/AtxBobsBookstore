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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-breaking, may indicate compatibility concerns with the new target framework.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Layer

Since a `Bookstore.Data` project is present, confirm that:

- The correct EF Core packages are referenced (not the legacy `EntityFramework` package).
- Any database migrations are compatible with EF Core by running:

```bash
dotnet ef migrations list
```

- The connection strings in your configuration files (e.g., `appsettings.json`) are correctly set up for your target database provider.

### 5. Review `Bookstore.Web` Configuration

For the web project, verify the following:

- `Program.cs` and `Startup.cs` (if applicable) follow the ASP.NET Core conventions.
- Any references to `System.Web` have been fully removed or replaced with ASP.NET Core equivalents.
- Static files, routing, and middleware are configured correctly.
- `appsettings.json` contains all necessary configuration that previously may have lived in `Web.config`.

### 6. Run the Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify that core functionality such as page rendering, data retrieval, and navigation are working as expected.

### 7. Review Remaining `Web.config` or `App.config` References

Check that no legacy configuration files are still being relied upon at runtime. Configuration should be handled through `appsettings.json` and the `IConfiguration` system in .NET.

### 8. Target Framework Verification

Open each `.csproj` file and confirm that the `<TargetFramework>` element references a supported modern version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Avoid targeting `net48` or any other legacy framework unless there is a specific dependency that requires it.