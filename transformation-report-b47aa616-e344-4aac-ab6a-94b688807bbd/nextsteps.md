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

Verify that no warnings or errors are produced during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- Any Entity Framework Core migrations are up to date. Run the following if needed:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add PostMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the connection string in `appsettings.json` is valid and points to the correct database instance for your environment.

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry forms, to confirm they behave correctly.

### 6. Check for Platform-Specific Code

Review the codebase for any remaining platform-specific APIs that may have been carried over from the legacy project. Common areas to check include:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows Registry access via `Microsoft.Win32`.
- Any P/Invoke calls that target Windows-only native libraries.
- File path separators hardcoded as `\` instead of using `Path.Combine` or `Path.DirectorySeparatorChar`.

### 7. Review Configuration

Confirm that configuration previously handled by `Web.config` or `App.config` has been correctly moved to `appsettings.json` and that the application reads these values correctly at runtime using the `IConfiguration` interface.

### 8. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.