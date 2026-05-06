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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-breaking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether the failures are due to the migration or pre-existing issues.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are valid and point to the correct database.
- Any Entity Framework Core migrations are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application to verify it runs correctly in the new cross-platform environment:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and manually verify that core application flows (e.g., browsing books, data retrieval) function as expected.

### 7. Check for Windows-Specific APIs

Even without build errors, certain APIs may have been carried over from the legacy project that behave differently or fail on non-Windows platforms. Review the codebase for usage of:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path separators (use `Path.Combine` and `Path.DirectorySeparatorChar` instead)
- `HttpContext.Current` (replaced by dependency-injected `IHttpContextAccessor`)

### 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, confirm that the application startup is using the modern `WebApplication` builder pattern introduced in .NET 6 and later:

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
```

If the project still uses the older `Startup.cs` and `Program.cs` pattern with `IHostBuilder`, consider migrating to the minimal hosting model for consistency with current .NET conventions.

### 9. Validate Logging and Configuration

Ensure that logging and configuration providers are correctly set up in `appsettings.json` and that environment-specific overrides (e.g., `appsettings.Production.json`) are in place and accurate for the target deployment environment.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce deployment artifacts:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all required files are present, including:

- The application binary and its dependencies
- `appsettings.json` and any environment-specific configuration files
- Static web assets (if applicable)

### 3. Deploy to Target Environment

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the target machine has the correct .NET runtime installed. You can verify the required runtime version from the `.csproj` `<TargetFramework>` value and download the appropriate runtime from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).