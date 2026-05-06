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

Check the output for any warnings that, while non-blocking, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects are still referencing `net48` or any other .NET Framework moniker unless intentionally targeting multiple frameworks.

### 4. Check for Windows-Specific Dependencies

Inspect each project for any NuGet packages or APIs that are Windows-only. Common examples include:

- `Microsoft.Win32` registry APIs
- `System.Drawing.Common` (requires additional configuration on Linux/macOS)
- Any COM interop references

Run the compatibility analyzer if not already enabled by adding the following to each `.csproj`:

```xml
<EnableNETAnalyzers>true</EnableNETAnalyzers>
<AnalysisMode>All</AnalysisMode>
```

### 5. Run Existing Tests

If a test project exists in the solution, execute the test suite to verify runtime behavior has not changed:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

### 6. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is present, confirm that any Entity Framework or data access configuration is functioning correctly:

- Verify the connection string is valid and accessible in the new environment.
- If using Entity Framework Core, confirm migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Web Application Locally

Start the web application and verify it loads correctly:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL indicated in the console output and manually verify that core application functionality is working as expected, including any pages that interact with the data layer.

### 8. Review `web.config` and `app.config` Migrations

If the original project used `web.config` or `app.config`, confirm that settings have been migrated to `appsettings.json` or environment variables, as these are the standard configuration mechanisms in modern .NET.

### 9. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and deployable:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected assets, static files, and binaries are present.