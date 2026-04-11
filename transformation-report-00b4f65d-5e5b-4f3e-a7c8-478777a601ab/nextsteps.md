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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-breaking, may indicate areas of concern such as obsolete APIs or nullable reference warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results carefully. Any failing tests should be investigated before proceeding further.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Platform-Specific APIs

Review the code in each project for any remaining usage of Windows-specific APIs that may not be available cross-platform. Common areas to check include:

- `System.Web` references in `Bookstore.Web`
- Registry access or Windows file path assumptions in `Bookstore.Data` or `Bookstore.Domain`
- Any use of `System.Drawing` without the `System.Drawing.Common` NuGet package

### 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework or another data access layer, verify that:

- The connection string is correctly configured in `appsettings.json`
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 7. Run the Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the core application workflows to confirm expected behavior, including any pages or features that interact with `Bookstore.Data` and `Bookstore.Domain`.

### 8. Review Application Logs

After running the application, review the console output and any structured log files for runtime exceptions or warnings that would not have surfaced during the build phase.

### 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all expected assemblies, static assets, and configuration files are present.