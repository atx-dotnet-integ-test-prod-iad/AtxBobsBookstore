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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output to confirm all three projects build with zero errors and note any warnings that may need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at a minimum:

- Application startup with no unhandled exceptions
- Database connectivity from `Bookstore.Data` (check connection strings in your configuration files such as `appsettings.json`)
- Core domain logic in `Bookstore.Domain` behaves as expected through the UI or API endpoints

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- Connection strings and application settings have been moved to `appsettings.json` or environment variables
- Any configuration transforms that previously existed in `Web.config` have been replicated in `appsettings.{Environment}.json` files
- Authentication, authorization, and middleware configurations are correctly set up in `Program.cs` or `Startup.cs`

### 6. Review Data Layer

Inspect `Bookstore.Data` to confirm the following:

- If Entity Framework is used, verify the version has been updated to EF Core and that migrations are present and functional
- Run any pending migrations against a development database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs that compiled successfully may behave differently or throw at runtime on non-Windows platforms. Search the codebase for usage of the following and validate their behavior:

- `System.Drawing` (not fully supported cross-platform without additional packages)
- Windows registry access
- File path separators (use `Path.Combine` rather than hardcoded backslashes)
- Any P/Invoke calls to Windows-specific native libraries

### 8. Review Deprecated or Replaced APIs

Check for use of APIs that have known differences in .NET compared to .NET Framework, including:

- `HttpContext.Current` (not available in ASP.NET Core)
- `Thread.Abort` (throws `PlatformNotSupportedException` in .NET 6+)
- Binary serialization via `BinaryFormatter` (disabled by default in .NET 6+)

Address any occurrences found during this review before proceeding to a production deployment.