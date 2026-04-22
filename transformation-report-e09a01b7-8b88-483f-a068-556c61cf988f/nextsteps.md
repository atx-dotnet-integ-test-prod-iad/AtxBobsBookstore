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

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless intentionally required.

### 4. Check for Windows-Specific APIs

Even without build errors, runtime failures can occur if the code uses Windows-specific APIs. Review the code for usages such as:

- `System.Windows.Forms`
- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- COM interop or P/Invoke calls targeting Windows DLLs

Use the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist with this review by adding the following to each `.csproj`:

```xml
<EnableNETAnalyzers>true</EnableNETAnalyzers>
<AnalysisMode>All</AnalysisMode>
```

### 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate runtime behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether failures are caused by the migration or pre-existing issues.

### 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- The connection string is correctly configured in `appsettings.json` or environment variables, replacing any `Web.config` or `App.config` entries that may have been used in the legacy project.
- If Entity Framework is in use, confirm the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Web Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary features to confirm expected behavior.

### 8. Review Configuration Migration

Confirm that any settings previously stored in `Web.config` or `App.config` have been properly moved to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application settings keys
- Authentication or authorization configuration

### 9. Deployment

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target hosting environment. Ensure the hosting environment has the appropriate .NET runtime installed. You can verify the required runtime version from the `<TargetFramework>` value in the `.csproj` file.