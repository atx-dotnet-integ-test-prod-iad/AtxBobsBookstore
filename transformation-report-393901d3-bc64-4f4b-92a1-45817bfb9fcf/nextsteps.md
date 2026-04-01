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

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless that is intentional.

### 4. Check for Windows-Specific Dependencies

Search the codebase for APIs or packages that are Windows-only, such as:

- `Microsoft.Win32` namespaces
- `System.Windows.Forms` or `System.Drawing` (without the `Common` variant)
- Any NuGet packages that list only `windows` as a supported runtime

These will not cause build errors but will cause runtime failures on non-Windows platforms.

### 5. Run Unit Tests

If the solution contains test projects, execute them to validate runtime behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests, as they may surface runtime incompatibilities that were not caught at compile time.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Walk through the primary user flows such as browsing, searching, and any data-driven pages to confirm that the `Bookstore.Data` and `Bookstore.Domain` layers are functioning correctly at runtime.

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that:

- The connection string in `appsettings.json` is valid for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- The EF Core provider package matches the target database (e.g., `Npgsql.EntityFrameworkCore.PostgreSQL` for PostgreSQL, `Microsoft.EntityFrameworkCore.SqlServer` for SQL Server).

### 8. Review Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (or `Startup.cs` if still present) to confirm:

- Middleware registration is compatible with the target .NET version.
- Any legacy `Startup.cs` patterns have been migrated to the minimal hosting model if targeting .NET 6 or later.
- Authentication, authorization, and routing configurations are functioning as expected.

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application for the target runtime:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

To target a specific runtime identifier, for example Linux x64:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release -r linux-x64 --self-contained false --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all expected assemblies, static assets, and configuration files are present before deploying to the target environment.