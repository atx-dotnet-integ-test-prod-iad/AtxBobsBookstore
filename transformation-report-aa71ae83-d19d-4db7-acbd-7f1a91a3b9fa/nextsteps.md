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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at runtime:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in your configuration files (e.g., `appsettings.json`) and ensure they are appropriate for the new environment.
- **Data access**: Exercise the data layer by performing typical read and write operations to confirm Entity Framework or any other ORM is functioning as expected.
- **Domain logic**: Walk through the core business workflows to confirm that the domain layer behaves correctly.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files to ensure settings previously held in `Web.config` or `App.config` have been correctly migrated. Pay particular attention to:

- Connection strings
- Authentication and authorization settings
- Logging configuration
- Any third-party service configuration

### 6. Check for Removed or Changed APIs

Review the code for any use of APIs that exist in .NET but behave differently from .NET Framework. Common areas to check include:

- `HttpContext` and request/response handling in `Bookstore.Web`
- Any use of `System.Web` namespaces, which are not available in cross-platform .NET
- Serialization behavior differences (e.g., `System.Text.Json` vs `Newtonsoft.Json`)

### 7. Deployment

Once local validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy them to your target hosting environment. Ensure the target environment has the appropriate .NET runtime installed and that any required environment variables or configuration overrides are in place.