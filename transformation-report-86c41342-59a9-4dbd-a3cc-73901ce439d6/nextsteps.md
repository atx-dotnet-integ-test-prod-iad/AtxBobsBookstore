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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated packages or version conflicts. Address any that appear.

### 2. Build the Solution

Perform a full solution build to confirm the clean state holds outside of the transformation environment:

```bash
dotnet build --configuration Release
```

Confirm that the output reports zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or target framework compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them now:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Walk through the primary application workflows, such as browsing, searching, and any data entry features, to confirm that runtime behavior matches the original legacy application.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example `net8.0`. Ensure all three projects are targeting a consistent framework version.

### 6. Review Removed Windows-Specific Dependencies

Check that any previously Windows-specific dependencies, such as `System.Web`, `HttpContext` from the classic ASP.NET stack, or Windows Registry access, have been fully replaced with their cross-platform equivalents. Search the codebase for any remaining references:

```bash
grep -r "System.Web" app/
grep -r "HttpRuntime" app/
grep -r "Registry" app/
```

Address any remaining references that are not compatible with cross-platform .NET.

### 7. Review Configuration and Middleware

If `Bookstore.Web` was migrated from ASP.NET MVC or Web Forms to ASP.NET Core, verify the following in `Program.cs` or `Startup.cs`:

- Middleware is registered in the correct order.
- Authentication and authorization configuration is present if required.
- Static file serving, routing, and session configuration are correct.
- Connection strings and application settings have been moved to `appsettings.json` and are being read via `IConfiguration`.

### 8. Database Compatibility

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The migration history is intact and compatible with the new runtime.
- Run `dotnet ef database update` to apply any pending migrations.
- Verify that the database provider package (for example, `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is the correct version for the target framework.

### 9. Static Analysis

Run a static analysis pass to identify any remaining code quality concerns introduced during migration:

```bash
dotnet build --configuration Release /p:TreatWarningsAsErrors=true
```

Review and resolve any warnings that are surfaced.

## Deployment

Once all validation steps above pass:

1. Publish the application using the appropriate runtime identifier for your target environment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

2. Verify the contents of the `./publish` directory contain the expected binaries and static assets.
3. Deploy the contents of the `./publish` directory to your target server or hosting environment according to your infrastructure's standard process.