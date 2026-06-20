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

Review the output for any warnings that may indicate compatibility concerns, even if they do not cause build failures.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is intact:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:
- Database connectivity from `Bookstore.Data`
- Domain logic correctness in `Bookstore.Domain`
- Page rendering and routing in `Bookstore.Web`

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET, such as `net8.0`:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project targets an older or end-of-life framework version, update it accordingly and re-run the build.

### 6. Check for Removed or Changed APIs

Review any usage of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` and related types, which have changed in ASP.NET Core
- Any Windows-specific APIs that may not function on non-Windows platforms

### 7. Review Configuration Files

Ensure that `appsettings.json` contains the correct configuration values, particularly connection strings that were previously stored in `Web.config` or `App.config`. Confirm that the application reads configuration correctly at runtime.

### 8. Validate Database Migrations

If the project uses Entity Framework, verify that migrations are up to date and apply cleanly against the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 9. Publish the Application

Once all validation steps pass, publish the application to confirm the output is complete and correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to your target environment.