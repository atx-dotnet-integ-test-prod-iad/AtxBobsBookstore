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

Check the output for any warnings that, while non-blocking, may indicate areas that need attention (e.g., nullable reference warnings, obsolete API usage).

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Runtime Behavior

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to pay particular attention to:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Configuration**: Ensure that any settings previously in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` and are being read at runtime.
- **Authentication and Authorization**: If the application uses any authentication middleware, verify that it initializes and functions correctly under the new framework.
- **Static files and routing**: Confirm that all routes resolve correctly and that static assets are served as expected.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or another legacy moniker, update it accordingly and rebuild.

### 6. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that are known to behave differently or have been removed in cross-platform .NET, including:

- `System.Web` namespace references (not available outside of ASP.NET on .NET Framework)
- `HttpContext` usage outside of the request pipeline
- Windows-specific APIs such as the registry, WMI, or COM interop
- `BinaryFormatter` (disabled by default in modern .NET)

### 7. Publish the Application

Once runtime behavior has been validated, publish the application to confirm the output is complete and self-contained:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, configuration, and assets are present before deploying to the target environment.