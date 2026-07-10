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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Review the NuGet package references in each `.csproj` file for any packages that are Windows-only or have known incompatibilities with cross-platform .NET. Common examples include:

- `System.Web` (not available in cross-platform .NET)
- `Microsoft.Web.*` packages
- Any COM interop or P/Invoke references targeting Windows APIs

### 5. Run Unit Tests

If the solution contains test projects, execute them to verify runtime behavior has not regressed:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and cross-platform .NET.

### 6. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, verify the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target framework version.
- Connection strings in configuration files (`appsettings.json`) are correct and accessible in the new project structure.
- Any migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally to validate end-to-end functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and verify that core functionality such as browsing, data retrieval, and any forms operate as expected.

### 8. Review Configuration Files

Confirm that any configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Connection strings
- Application settings keys
- Authentication or authorization configuration

### 9. Check Static Files and Middleware (Bookstore.Web)

If the web project previously relied on ASP.NET MVC on .NET Framework, verify that the middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured for ASP.NET Core, including:

- Static file serving (`UseStaticFiles`)
- Routing (`UseRouting`, `MapControllers`, or `MapRazorPages`)
- Authentication and authorization middleware order