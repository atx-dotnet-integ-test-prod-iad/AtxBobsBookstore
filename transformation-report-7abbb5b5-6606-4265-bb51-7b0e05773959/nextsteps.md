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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup completes without exceptions
- Database connectivity works as expected through `Bookstore.Data`
- Domain logic in `Bookstore.Domain` produces correct results
- All major routes and pages in `Bookstore.Web` load and function correctly

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version of .NET, for example `net8.0`. Ensure all three projects are targeting a consistent framework version.

### 6. Check for Deprecated or Removed APIs

Review the code for any use of APIs that existed in .NET Framework but have changed behavior or limited support in modern .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- Any Windows-specific APIs that may compile but fail at runtime on non-Windows platforms
- Entity Framework usage in `Bookstore.Data`, ensuring it has been migrated to Entity Framework Core if applicable

### 7. Review Configuration Files

Confirm that configuration has been properly migrated from `Web.config` or `App.config` to the `appsettings.json` format used in modern .NET. Verify that connection strings, application settings, and environment-specific values are present and correct.

### 8. Test on Target Platform

If the goal is cross-platform support, run and test the application on the intended non-Windows platform (Linux or macOS) to surface any platform-specific runtime issues that would not appear during development on Windows.

### 9. Deployment

Once all validation steps pass, publish the application using the following command:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy it to your target hosting environment according to your infrastructure requirements.