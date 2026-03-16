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

Check the output for any warnings, particularly around nullable reference types, obsolete APIs, or platform compatibility that may have been introduced during the transformation.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results carefully. Any failing tests should be investigated before proceeding.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, confirm the following areas are functioning as expected:

- **Database connectivity**: Ensure `Bookstore.Data` can connect to the database. If the project previously used a Windows-specific connection string or SQL Server authentication method (such as Windows Integrated Security), update the connection string in `appsettings.json` to use a cross-platform compatible method.
- **Data access layer**: Verify that Entity Framework Core migrations (if applicable) are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the primary domain workflows through the UI or API endpoints to confirm correct behavior.

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) for values that may have been tied to the legacy Windows environment, such as:

- File paths using Windows-style separators (replace with `Path.Combine` or forward slashes where applicable)
- Windows-specific authentication or identity configurations
- Hardcoded machine names or environment-specific endpoints

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs may compile successfully but fail at runtime on non-Windows platforms. Review the codebase for usage of the following and test on the target platform:

- `System.Drawing` (GDI+ is not fully supported on Linux/macOS without additional packages)
- Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file system assumptions (drive letters, UNC paths)

### 7. Validate Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file for the `<TargetFramework>` element:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects to avoid inter-project compatibility issues.

---

Once all of the above steps have been completed without errors or unexpected behavior, the migration can be considered validated.