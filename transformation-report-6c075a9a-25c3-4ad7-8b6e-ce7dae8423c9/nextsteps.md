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

Check the output for any warnings that, while non-blocking, may indicate deprecated APIs or framework-specific code that could cause runtime issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated as they may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the `Bookstore.Web` project and manually verify core application functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Pay particular attention to the following areas, as they are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in `appsettings.json` and ensure the correct database provider NuGet package is referenced.
- **Entity Framework migrations**: If Entity Framework is used, verify that existing migrations are compatible with the new EF Core version. Run `dotnet ef database update` if needed.
- **Configuration**: Ensure that any settings previously stored in `Web.config` or `App.config` have been correctly moved to `appsettings.json` or environment variables.
- **Static files and routing**: Confirm that pages, routes, and static assets load correctly in the browser.

### 5. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas manually:

- Any use of `System.Web` namespaces, which are not available in .NET Core or later.
- Windows-specific APIs such as the registry, WCF server-side components, or `System.Drawing` (GDI+), which may require replacement packages or alternative implementations.
- HTTP module and HTTP handler patterns, which should be replaced with ASP.NET Core middleware.

### 6. Check the Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-targeting issues.

### 7. Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy them to the target hosting environment. Ensure the target server has the appropriate .NET runtime installed, which can be confirmed by running:

```bash
dotnet --info
```