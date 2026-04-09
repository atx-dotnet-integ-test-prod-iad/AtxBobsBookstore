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

Check the output for any warnings that, while non-breaking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the transformation:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Data Layer

Since `Bookstore.Data` is likely responsible for database access, verify the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider appropriate for your database).
- Any connection strings in configuration files (`appsettings.json`) are correct and accessible in the new runtime environment.
- Run any pending Entity Framework Core migrations, if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and test core functionality, paying particular attention to:

- Database connectivity and data retrieval
- Any file system operations, as path handling may differ across operating systems
- Authentication and session handling, if present

### 6. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json` if present) contains all configuration values that were previously held in `Web.config` or `App.config`. Common items to check include:

- Connection strings
- Application settings / feature flags
- Logging configuration

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs may have changed behavior on non-Windows platforms. Review the codebase for usage of the following and test accordingly:

- `System.Drawing` (not fully supported cross-platform without additional packages)
- Windows Registry access
- Windows-specific file path assumptions (backslashes, drive letters)
- `HttpContext.Current` (not available in ASP.NET Core)

### 8. Deployment

Once local validation is complete, publish the application using the following command, targeting your desired runtime:

```bash
dotnet publish --project Bookstore.Web --configuration Release --runtime linux-x64 --self-contained false
```

Replace `linux-x64` with the appropriate runtime identifier for your target environment (e.g., `win-x64`, `osx-x64`). The output will be placed in the `publish` directory and can be deployed to your target host.