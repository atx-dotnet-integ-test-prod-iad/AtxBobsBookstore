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

Review the output for any warnings related to package compatibility or version conflicts.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element reflects the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results and address any failing tests before proceeding.

### 5. Verify Database Connectivity (Bookstore.Data)

- Confirm that the connection string in `appsettings.json` or `appsettings.Production.json` is valid for the target environment.
- If Entity Framework Core is in use, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL printed in the console output and verify core functionality such as page rendering, data retrieval, and form submissions.

### 7. Check for Windows-Specific API Usage

Even without build errors, there may be runtime issues caused by Windows-specific APIs that are not available on Linux or macOS. Search the codebase for usages of the following:

- `Microsoft.Win32`
- `System.Windows`
- `Registry`
- `Environment.SpecialFolder` paths that are Windows-specific

Replace any such usages with cross-platform alternatives where applicable.

### 8. Review Middleware and Configuration (Bookstore.Web)

- Confirm that `Program.cs` follows the minimal hosting model pattern used in modern .NET.
- Verify that any previously used `Startup.cs` has been consolidated into `Program.cs` if it has not been done already.
- Check that static file serving, routing, and authentication middleware are configured correctly.

### 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present.