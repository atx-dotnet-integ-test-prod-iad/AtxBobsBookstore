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

Review the output for any warnings related to package compatibility or missing packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not cause outright build failures.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). For example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target a consistent framework version.

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and address regressions introduced during the transformation.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- Connection strings in `appsettings.json` or equivalent configuration files are correct for the target environment.
- Any Entity Framework Core migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary workflows to check for runtime exceptions or unexpected behavior.

### 7. Check for Windows-Specific APIs

Even without build errors, the code may reference APIs that only function on Windows. Search the codebase for usages of the following and test them on your target platform:

- `Microsoft.Win32`
- `System.Windows`
- `Registry`
- `System.Drawing` (without the `System.Drawing.Common` package configured)

If any are found, evaluate whether a cross-platform alternative is needed.

### 8. Review Middleware and Configuration (Bookstore.Web)

Confirm that the ASP.NET Core middleware pipeline in `Program.cs` or `Startup.cs` is configured correctly for the new .NET version. Pay particular attention to:

- Authentication and authorization middleware
- Static file handling
- Any custom HTTP modules or handlers that may have been carried over from a legacy ASP.NET (non-Core) project

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all required files, static assets, and configuration files are present.

### 3. Test the Published Output

Run the published output directly to confirm it behaves identically to the development build:

```bash
dotnet ./publish/Bookstore.Web.dll
```