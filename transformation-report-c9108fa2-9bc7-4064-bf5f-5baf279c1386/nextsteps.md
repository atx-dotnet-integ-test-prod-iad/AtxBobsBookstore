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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated packages or version conflicts that may not surface as build errors but could cause runtime issues.

### 2. Build the Solution

Perform a full solution build to confirm the clean state:

```bash
dotnet build --configuration Release
```

Verify that the output confirms zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or target framework compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them now:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects exist, consider writing basic unit tests for the domain and data layers to verify core logic behaves as expected after the migration.

### 4. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The connection string in `appsettings.json` is correct for your target environment.
- Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, to confirm end-to-end functionality.

### 6. Review Configuration Files

Check the following configuration concerns that are common after a migration from legacy .NET Framework:

- `appsettings.json` and `appsettings.Development.json` contain all settings that were previously in `Web.config` or `App.config`.
- Any connection strings, API keys, or application settings have been correctly ported over.
- Authentication and authorization middleware, if present, is correctly configured in `Program.cs` or `Startup.cs`.

### 7. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but have limited or no support in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows Registry access (`Microsoft.Win32.Registry`).
- `AppDomain` usage beyond what is supported in .NET Core and later.
- Any P/Invoke calls targeting Windows-only native libraries.

You can use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tooling to assist with this check.

### 8. Deployment

Once local validation is complete, publish the application using the appropriate runtime identifier for your target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained false
```

Replace `linux-x64` with your target runtime identifier (e.g., `win-x64`, `osx-x64`) as needed. Review the published output directory to confirm all required assets are present before deploying to the target server.