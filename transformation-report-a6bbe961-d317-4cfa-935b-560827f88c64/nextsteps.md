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

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, confirm that your database connection strings in `appsettings.json` (or equivalent configuration files) are correct for your target environment. If the project uses Entity Framework, apply or verify migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that pages load correctly, data is retrieved and saved as expected, and no runtime exceptions occur.

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to your intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version.

### 7. Review Removed Windows-Specific Dependencies

Check that no references to Windows-specific libraries (such as `System.Web`, `Microsoft.Web.*`, or Windows Registry APIs) remain in any project. Search the solution for any remaining usages:

```bash
grep -r "System.Web" .
```

Replace or remove any references that are not compatible with cross-platform .NET.

### 8. Check Configuration Migration

Confirm that any configuration previously held in `Web.config` or `App.config` has been properly moved to `appsettings.json` and that the application reads configuration values using `Microsoft.Extensions.Configuration` patterns.

### 9. Validate Static Files and Middleware

If `Bookstore.Web` serves static files or uses middleware, confirm that the middleware pipeline in `Program.cs` (or `Startup.cs`) is correctly configured, including calls to `UseStaticFiles()`, `UseRouting()`, and `UseAuthorization()` where applicable.