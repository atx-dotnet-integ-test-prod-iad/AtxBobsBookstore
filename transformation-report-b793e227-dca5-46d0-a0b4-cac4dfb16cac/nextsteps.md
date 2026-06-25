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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test
```

Review test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually test core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Specifically, verify the following areas:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is used, verify that migrations apply cleanly with `dotnet ef database update`.
- **Domain logic**: Exercise the key business logic paths defined in `Bookstore.Domain` to confirm correct behavior.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Check for Removed or Changed APIs

Review the code for any usage of APIs that exist in .NET Framework but behave differently or have been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- `ConfigurationManager`, which requires the `System.Configuration.ConfigurationManager` NuGet package.
- Windows-specific APIs such as the registry or certain security namespaces.
- Any third-party libraries that may still target .NET Framework only.

### 6. Review Target Frameworks

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing target frameworks across projects in the same solution can cause compatibility issues at runtime even when the build succeeds.

### 7. Publish the Application

Once runtime validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all expected assemblies, static assets, and configuration files are present before deploying to the target environment.