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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Verify Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Review the project files and source code for any remaining references to Windows-specific APIs or libraries, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- COM interop

These will not function correctly on non-Windows platforms even if the build succeeds.

### 5. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the core functionality, including any pages or features that interact with the `Bookstore.Data` and `Bookstore.Domain` layers.

### 6. Run Existing Tests

If the solution contains test projects, execute them to validate that business logic and data access behavior remain correct after the migration:

```bash
dotnet test
```

Review any failing tests and determine whether failures are caused by migration-related changes or pre-existing issues.

### 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- The database schema matches what the application expects.

### 8. Test on a Non-Windows Platform (Optional but Recommended)

If cross-platform support is a goal, run the application on Linux or macOS to confirm there are no runtime dependencies on Windows-specific behavior that were not caught at build time.