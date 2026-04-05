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

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another ORM, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, user authentication, and any data entry forms.

### 7. Check for Windows-Specific API Usage

Even without build errors, certain APIs may have been available on .NET Framework but behave differently or throw `PlatformNotSupportedException` at runtime on non-Windows platforms. Review the code for usage of:

- `System.Web` namespaces (these are not available in modern .NET)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

### 8. Review Configuration Files

Ensure that `Web.config` or `App.config` settings have been migrated to `appsettings.json` and that the application reads configuration correctly using `IConfiguration`. Verify connection strings, application settings, and any environment-specific values are present.

### 9. Test on Target Platform

If cross-platform support is a goal, run the application on the target operating system (e.g., Linux or macOS) to surface any remaining platform-specific issues that would not appear during a Windows build.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce deployment artifacts:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify Published Output

Inspect the `./publish` directory to confirm all required files are present, including static assets, configuration files, and dependent assemblies.

### 3. Configure the Runtime Environment

Ensure the target server has the correct .NET runtime installed. You can verify the required runtime version from the `<TargetFramework>` value in the `.csproj` file and download the appropriate hosting bundle from the [.NET download page](https://dotnet.microsoft.com/download).

### 4. Validate in a Staging Environment

Deploy the published output to a staging environment that mirrors production. Run smoke tests against the staged deployment before promoting to production.