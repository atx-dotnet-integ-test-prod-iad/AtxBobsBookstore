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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). For example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target a consistent framework version.

### 4. Run Unit Tests

If a test project exists in the solution, execute the tests to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by incomplete migration of dependencies.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Any connection strings in `appsettings.json` are valid and accessible from the new runtime environment.
- Run any pending migrations to confirm the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary user flows, such as browsing books, searching, and any authentication flows if present.

### 7. Check for Windows-Specific API Usage

Even without build errors, the code may reference APIs that only function correctly on Windows. Search the codebase for usages of the following and assess whether cross-platform alternatives are needed:

- `System.Web` namespaces
- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `HttpContext.Current`

### 8. Review Removed or Changed APIs

Certain APIs available in .NET Framework are absent or behave differently in modern .NET. Review the [.NET Upgrade Assistant compatibility analyzer output](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if it was used during transformation, and address any suppressed or deferred compatibility warnings.

## Deployment

### 1. Publish the Application

Publish the application to a self-contained or framework-dependent deployment:

```bash
# Framework-dependent
dotnet publish Bookstore.Web --configuration Release --output ./publish

# Self-contained (example for Linux x64)
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all required files, static assets, and configuration files are present.

### 3. Configure the Hosting Environment

- For **IIS**: Install the [.NET Hosting Bundle](https://dotnet.microsoft.com/en-us/download/dotnet) on the server and configure the application pool to use "No Managed Code" with the ASP.NET Core Module.
- For **Kestrel / reverse proxy**: Ensure the target server has the correct .NET runtime installed and that a reverse proxy (e.g., Nginx or IIS) is configured to forward requests appropriately.

### 4. Validate Configuration Files

Confirm that `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`) contain the correct values for the production environment, particularly connection strings and any API keys.