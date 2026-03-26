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

## Validation Steps

### 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

### 4. Check for Windows-Specific APIs

Even without build errors, some APIs may have been carried over from the legacy project that are Windows-specific. Run the .NET compatibility analyzer to surface any such issues:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Review any `CA1416` platform compatibility warnings in the output.

### 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify runtime behavior:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test project exists, consider adding one to cover critical paths in `Bookstore.Domain` and `Bookstore.Data`.

### 6. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another ORM, verify the following:

- Connection strings in `appsettings.json` are correct for the target environment.
- Run any pending migrations to confirm the data layer functions as expected:

```bash
dotnet ef database update
```

- If migrations do not exist yet, generate them:

```bash
dotnet ef migrations add InitialMigration
dotnet ef database update
```

### 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm end-to-end functionality.

### 8. Test on a Non-Windows Platform (If Required)

If cross-platform support is a goal, run the application on Linux or macOS to confirm there are no platform-specific runtime issues that were not caught at compile time.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check application logs for any runtime exceptions related to file paths, registry access, or other OS-specific behavior.

### 9. Review Configuration and Environment Variables

Confirm that any configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` and that environment-specific settings are handled using the appropriate .NET configuration providers.

### 10. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.