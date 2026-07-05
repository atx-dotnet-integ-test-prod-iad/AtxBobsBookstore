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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while non-blocking, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test
```

Review test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually exercise core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas in particular:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, verify that migrations apply cleanly with `dotnet ef database update`.
- **Domain logic**: Walk through key business workflows to confirm that `Bookstore.Domain` behaves as expected.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work correctly.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Cross-platform .NET does not include certain APIs that were available in .NET Framework. Review the following areas for potential runtime issues even if the build succeeds:

- `System.Web` references, which are not available outside of ASP.NET Core.
- `BinaryFormatter`, which is disabled by default in modern .NET.
- Windows-specific APIs such as the registry or certain `System.Drawing` features.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining compatibility concerns.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.