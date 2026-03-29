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

Check the output for any warnings that, while non-breaking, may indicate deprecated APIs or compatibility concerns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Pay particular attention to the following areas, as they are common sources of runtime issues after migration even when the build succeeds:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. Check your connection strings in `appsettings.json`, as the format or provider may have changed.
- **Entity Framework migrations**: If using Entity Framework, verify that migrations apply cleanly:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Authentication and authorization**: If the application uses ASP.NET Identity or cookie-based auth, validate that login and role-based access function correctly.
- **Static files and routing**: Confirm that pages, views, and API routes resolve as expected.

### 5. Review Configuration Files

Compare the original `Web.config` (if it existed) with the new `appsettings.json` to ensure all application settings, connection strings, and environment-specific values have been carried over correctly. The `System.Configuration` APIs are not available in cross-platform .NET, so any remaining references to them should be replaced with `Microsoft.Extensions.Configuration`.

### 6. Check for Platform-Specific Code

Search the codebase for any remaining usage of Windows-specific APIs that may compile successfully but fail at runtime on non-Windows environments:

- `System.Drawing` (use a supported alternative such as `SkiaSharp` or `ImageSharp` if image processing is needed)
- Windows registry access
- COM interop
- `HttpContext.Current` (replace with injected `IHttpContextAccessor`)

### 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an actively supported version, such as `net8.0`. If it is set to `net6.0` or `net7.0`, consider upgrading as those versions are out of support or approaching end of life.

```xml
<TargetFramework>net8.0</TargetFramework>
```