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

## Validation Steps

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Verify that no warnings or errors appear related to missing or incompatible packages.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any compile-time errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing behavior is preserved:

```bash
dotnet test --configuration Release
```

Address any failing tests before proceeding.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are valid and point to the correct database.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, apply them with:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm expected behavior.

### 7. Check for Windows-Specific API Usage

Even without build errors, the code may contain Windows-specific APIs that will fail at runtime on non-Windows platforms. Use the .NET compatibility analyzer to surface these:

```bash
dotnet build /p:PlatformTarget=AnyCPU
```

Additionally, search the codebase for usages of APIs such as `System.Drawing`, `Microsoft.Win32`, or `RegistryKey`, and replace them with cross-platform alternatives where necessary.

### 8. Review Middleware and Configuration (Bookstore.Web)

Confirm that the `Program.cs` or `Startup.cs` file follows the expected structure for the target .NET version. Ensure middleware such as authentication, authorization, static files, and routing is configured correctly and that no legacy `System.Web` references remain.

### 9. Validate Static Assets and Views

If the project uses Razor views or static files, confirm they are served correctly by checking the `wwwroot` folder structure and that the `UseStaticFiles()` middleware is present in the application pipeline.

## Deployment

Once all of the above validation steps pass without errors:

1. Publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

2. Verify the contents of the `./publish` folder contain all expected binaries and static assets.
3. Deploy the contents of the `./publish` folder to your target hosting environment, ensuring the runtime environment has the matching .NET version installed.