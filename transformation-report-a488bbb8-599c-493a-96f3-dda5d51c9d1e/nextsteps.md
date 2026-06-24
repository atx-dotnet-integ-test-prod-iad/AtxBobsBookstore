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

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that may indicate compatibility concerns, even if they do not prevent compilation.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, validate the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check your connection strings in `appsettings.json` and ensure they are appropriate for the target environment.
- **Domain logic**: Exercise the primary business workflows to confirm that `Bookstore.Domain` behaves correctly.
- **Web layer**: Navigate through the application pages and verify that routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm that:

- All configuration values previously in `Web.config` have been migrated to `appsettings.json`.
- Any environment-specific settings are handled via `appsettings.{Environment}.json` or environment variables.
- Connection strings are present and correctly formatted.

### 6. Check for Windows-Specific Dependencies

Even without build errors, runtime issues can arise from APIs that exist in .NET but behave differently across operating systems. Review the codebase for usage of:

- `System.Drawing` (GDI+ is not fully supported on Linux/macOS without additional packages)
- Windows registry access
- Windows-specific file path assumptions (e.g., backslashes)
- COM interop or P/Invoke calls targeting Windows libraries

### 7. Review Entity Framework Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework, verify that your migrations are compatible with the current EF Core version:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a test database before pointing to a production database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is as expected:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.