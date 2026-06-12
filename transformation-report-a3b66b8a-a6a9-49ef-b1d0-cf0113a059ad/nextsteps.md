# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects in the solution:

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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs or framework-specific code that may have been carried over from the legacy project.

### 3. Run Unit Tests

If the solution contains test projects, execute them now:

```bash
dotnet test
```

Review test results carefully. Failures at this stage may indicate behavioral differences between the old .NET Framework runtime and the new cross-platform .NET runtime, even if the code compiles cleanly.

### 4. Review Runtime Behavior

Start the web application locally and exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that Entity Framework migrations (if any) apply correctly.
- **Routing and pages**: Navigate through the application and verify that all pages load and respond as expected.
- **Static assets**: Confirm that CSS, JavaScript, and image assets are served correctly.
- **Configuration**: Verify that `appsettings.json` contains all necessary configuration values that were previously in `Web.config` or `App.config`.

### 5. Check for Windows-Specific API Usage

Even without build errors, the codebase may reference APIs that only function correctly on Windows. Search the codebase for the following:

- `System.Web` namespace usage (not supported on cross-platform .NET)
- `Registry` or `RegistryKey` usage from `Microsoft.Win32`
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `HttpContext.Current` usage, which behaves differently outside of ASP.NET Framework

If any of these are found, they will need to be replaced with their cross-platform equivalents.

### 6. Validate the Data Layer

Confirm that the `Bookstore.Data` project is using a version of Entity Framework compatible with the target .NET version. If the project was migrated from Entity Framework 6, consider whether a migration to Entity Framework Core is appropriate, as EF6 has limited support on cross-platform .NET.

Run any pending migrations and verify the schema:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid inter-project compatibility issues.

### 8. Deploy to a Target Environment

Once local validation is complete, deploy the application to your target environment:

```bash
dotnet publish --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server and run the application, confirming that all runtime behavior matches what was validated locally.