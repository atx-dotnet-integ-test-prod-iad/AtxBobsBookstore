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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or unit tests covering the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`.

### 5. Verify Runtime Behavior

Run the web application locally and manually verify key functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas in particular:

- Database connectivity and data retrieval through `Bookstore.Data`
- Correct rendering of pages or API responses from `Bookstore.Web`
- Any features that relied on Windows-specific APIs or libraries in the legacy project, as these may fail at runtime even without build errors

### 6. Check for Windows-Specific Dependencies

Review the code in all three projects for usage of APIs that are not supported cross-platform, such as:

- `System.Web` namespaces (common in legacy ASP.NET projects)
- Windows Registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `System.Drawing` (has limited cross-platform support; consider replacing with a library such as `SkiaSharp` or `ImageSharp` if used)

### 7. Review Configuration and Connection Strings

Confirm that configuration files such as `appsettings.json` are properly set up and that any connection strings previously stored in `Web.config` have been migrated correctly. The legacy `Web.config` is not used in cross-platform .NET; all configuration should flow through `appsettings.json` or environment variables.

### 8. Publish the Application

Once runtime behavior has been validated, publish the application to confirm a clean release output:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files and assets are present before deploying to the target environment.