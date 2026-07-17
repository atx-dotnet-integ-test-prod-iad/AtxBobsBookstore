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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by pre-existing issues.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Specifically, check the following areas:

- **Data access**: Confirm that database connections and queries in `Bookstore.Data` function correctly. If Entity Framework is used, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the key business logic paths exposed by `Bookstore.Domain` to confirm expected outputs.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work correctly.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- Settings have been migrated to `appsettings.json` and are being read correctly via `IConfiguration`.
- Connection strings are present and valid in `appsettings.json` or environment variables.
- Any environment-specific settings (e.g., `appsettings.Development.json`) are in place.

### 6. Check for Removed or Changed APIs

Review the code for any use of APIs that exist in .NET but behave differently from .NET Framework. Common areas to inspect include:

- `HttpContext` and related web APIs in `Bookstore.Web`
- Any use of `System.Web` namespaces, which are not available in cross-platform .NET
- Serialization behavior differences (e.g., `System.Text.Json` vs `Newtonsoft.Json`)

### 7. Target Framework Confirmation

Open each `.csproj` file and confirm that the `<TargetFramework>` element references a current and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid targeting `net6.0` or earlier unless there is a specific requirement, as those versions are out of support or approaching end of life.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is as expected:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.