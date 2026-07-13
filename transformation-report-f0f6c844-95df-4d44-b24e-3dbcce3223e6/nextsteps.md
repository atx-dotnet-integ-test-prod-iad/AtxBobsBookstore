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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns worth addressing before deployment.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests that previously passed under the legacy framework should be investigated and resolved before proceeding.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas, as they are common sources of runtime issues after cross-platform migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If the project previously used `System.Data.SqlClient`, ensure it has been migrated to `Microsoft.Data.SqlClient` and that connection strings are valid in the new environment.
- **Configuration loading**: Verify that `appsettings.json` (and environment-specific variants) are being read correctly, particularly if the project previously relied on `Web.config` or `App.config`.
- **Static files and routing**: Confirm that pages, assets, and API routes resolve as expected in the migrated web project.
- **Entity Framework migrations**: If `Bookstore.Data` uses Entity Framework, run the following to confirm the database schema is up to date:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references an actively supported version of .NET (for example, `net8.0`). If any project targets a version that is out of support or nearing end of life, plan an upgrade accordingly.

### 6. Check for Platform-Specific APIs

Search the codebase for any APIs that were available in .NET Framework but have limited or no support in cross-platform .NET. Common areas to check include:

- `System.Web` namespace usage
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side components
- `AppDomain` usage beyond what is supported in .NET Core and later

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to assist with this review if needed.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all expected files, including configuration files and static assets, are present before deploying to the target environment.