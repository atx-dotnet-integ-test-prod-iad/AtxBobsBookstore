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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific APIs

Even without build errors, the code may still use Windows-specific APIs that will fail at runtime on non-Windows platforms. Run the .NET compatibility analyzer by adding the following to each `.csproj` if not already present:

```xml
<PropertyGroup>
  <EnableNETAnalyzers>true</EnableNETAnalyzers>
  <AnalysisMode>All</AnalysisMode>
  <PlatformNeutralAssembly>true</PlatformNeutralAssembly>
</PropertyGroup>
```

Rebuild and review any new analyzer warnings, particularly those prefixed with `CA1416`.

### 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate runtime behavior:

```bash
dotnet test --configuration Release
```

Address any test failures that surface runtime incompatibilities not caught at compile time.

### 6. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another ORM, verify the following:

- The database provider package is compatible with the target .NET version.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Connection strings in configuration files (`appsettings.json`) are correct for the target environment.

### 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

### 8. Review Configuration Files

Confirm that any settings previously stored in `Web.config` or `App.config` have been properly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Connection strings
- Application settings keys
- Authentication or authorization configuration

### 9. Validate Static Assets and Middleware

If `Bookstore.Web` serves static files or uses middleware that was previously handled by IIS (e.g., URL rewriting, compression), confirm that equivalent middleware is registered in `Program.cs` or `Startup.cs`, for example:

```csharp
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
```

### 10. Test on Target Platform

If the goal is cross-platform deployment, run and test the application explicitly on the target operating system (Linux or macOS) to surface any remaining platform-specific issues that would not appear on Windows.