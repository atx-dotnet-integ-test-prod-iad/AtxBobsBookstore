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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new runtime.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm that:

- The connection string in your configuration file (`appsettings.json` or similar) is correct for your target environment.
- Any Entity Framework migrations are up to date by running:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If you were previously using `App.config` for connection strings, ensure those values have been moved to `appsettings.json` in `Bookstore.Web`.

### 6. Run the Web Application Locally

Start the web application and perform basic smoke testing:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core pages load, data is retrieved correctly, and no runtime exceptions are thrown.

### 7. Check for Windows-Specific APIs

Even without build errors, runtime failures can occur if the code relies on Windows-specific APIs (e.g., the registry, certain `System.Web` members, or Windows Authentication). Test the application on the target platform (Linux or macOS if applicable) to surface any such issues.

### 8. Review Removed or Changed APIs

Cross-reference your codebase against the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/net-compatibility-analyzer) output to identify any APIs that were available in .NET Framework but behave differently or are absent in modern .NET.

### 9. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server and configure the web server (IIS, Kestrel, or Nginx) to serve the application according to the [official ASP.NET Core hosting documentation](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/).