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

Run the following command from the root of the solution to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Verify that the restore completes without warnings or errors related to missing packages or incompatible target frameworks.

### 2. Build the Solution

Run a full solution build to confirm the clean state:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while non-blocking, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Run Unit Tests

If test projects exist within the solution, execute them to verify that business logic and data access behavior remain intact after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results carefully, paying particular attention to any tests covering data access in `Bookstore.Data` or domain logic in `Bookstore.Domain`.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 5. Check for Windows-Specific APIs

Even without build errors, runtime failures can occur if any Windows-specific APIs were carried over. Review the following areas:

- **`Bookstore.Data`**: Confirm that the database provider (e.g., Entity Framework Core) is configured for cross-platform use. If SQL Server is used, ensure the connection string and provider are compatible with the target environment.
- **`Bookstore.Web`**: Check `Program.cs` and any middleware configuration for references to Windows-specific hosting features such as `UseIIS()` or Windows Authentication, and replace or conditionally compile them if needed.

### 6. Review Configuration Files

Ensure that `appsettings.json` is present and correctly structured for the new hosting model. If the project previously used `Web.config`, confirm that relevant settings (connection strings, app settings) have been migrated to `appsettings.json`.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

### 7. Run the Application Locally

Start the web application locally to perform a basic smoke test:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the displayed local URL and verify that core pages load and that data access (e.g., listing books) functions as expected.

### 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all expected assemblies and static assets are present before deploying to the target environment.