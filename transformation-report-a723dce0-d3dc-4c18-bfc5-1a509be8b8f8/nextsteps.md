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

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that were not fully modernized.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new target framework.

### 4. Verify Runtime Behavior

Start the `Bookstore.Web` project locally and manually verify core application flows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas in particular:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations apply cleanly with `dotnet ef database update`.
- **Domain logic**: Exercise the primary business logic paths exposed through `Bookstore.Domain` to confirm correct behavior.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a currently supported version of .NET, such as `net8.0`. Avoid targeting `net6.0` or `net7.0` as these are out of support.

```xml
<TargetFramework>net8.0</TargetFramework>
```

### 6. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Perform a search across the codebase for common problem areas:

- `System.Web` references
- `HttpContext` usage outside of ASP.NET Core's dependency injection
- `ConfigurationManager` usage (should be replaced with `IConfiguration`)
- Windows-specific APIs such as the registry or certain `System.Drawing` methods

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining compatibility concerns.

### 7. Check Application Configuration

Ensure that `web.config` settings have been properly migrated to `appsettings.json` and that the application reads configuration through the standard `IConfiguration` interface provided by ASP.NET Core.

### 8. Deployment

Once the above validation steps pass, publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target hosting environment. Ensure the target server has the appropriate .NET runtime installed, which can be verified with:

```bash
dotnet --info
```