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

Check the output for any warnings that, while non-breaking, may indicate areas that need attention, such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas which are commonly affected by cross-platform migrations:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, run or verify any pending migrations.
- **File paths**: Ensure no hardcoded Windows-style paths (e.g., `C:\...` or backslash separators) exist in configuration files or code, as these will fail on Linux and macOS.
- **Configuration**: Verify that `appsettings.json` or equivalent configuration files are present and correctly read at runtime, replacing any legacy `Web.config` or `App.config` values that may have been in use.
- **Authentication and Session**: If the application uses ASP.NET authentication, confirm that cookies, sessions, and any identity middleware are functioning correctly under the new runtime.

### 5. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were removed or significantly changed in cross-platform .NET. Common problem areas include:

- `System.Web` namespace usage, which is not available outside of ASP.NET Framework.
- `BinaryFormatter`, which is disabled by default in modern .NET.
- `AppDomain` APIs with limited support.
- Windows-specific registry or COM interop calls.

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling can assist in identifying remaining compatibility issues.

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and currently supported version of .NET.

### 7. Review NuGet Package Versions

Check that all referenced NuGet packages are compatible with the target framework. Replace any packages that have known cross-platform replacements, such as:

- `System.Drawing.Common` on non-Windows platforms requires additional native dependencies or should be replaced with an alternative imaging library.
- Any packages still targeting `net45` or similar legacy monikers should be updated to their current versions.