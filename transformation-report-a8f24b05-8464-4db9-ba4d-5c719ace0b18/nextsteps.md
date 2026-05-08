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

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the current .NET runtime.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- Connection strings in `appsettings.json` are correct for the target environment.
- Any Entity Framework migrations are up to date. Run the following if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If you are using a database provider that was previously Windows-only (e.g., certain SQL Server configurations), verify that the provider package supports cross-platform execution.

### 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test primary workflows such as browsing, searching, and any authentication flows.

### 7. Check for Windows-Specific API Usage

Even without build errors, runtime issues can arise from Windows-specific APIs that compile successfully but fail on non-Windows platforms. Search the codebase for usages of:

- `Microsoft.Win32` namespaces
- `Registry` access
- Windows file path assumptions (e.g., hardcoded backslashes)
- `System.Drawing` (which has platform limitations on non-Windows)

Replace any such usages with cross-platform alternatives where necessary.

### 8. Review Middleware and Configuration (Bookstore.Web)

If the web project was previously an ASP.NET (System.Web) application, confirm that the migration to ASP.NET Core is complete:

- `Startup.cs` or the top-level `Program.cs` is properly configured.
- Authentication, session, and routing middleware are correctly registered.
- Any `HttpContext` usages have been updated to the ASP.NET Core equivalents.

### 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify all required assets, configuration files, and dependencies are present before deploying to the target environment.