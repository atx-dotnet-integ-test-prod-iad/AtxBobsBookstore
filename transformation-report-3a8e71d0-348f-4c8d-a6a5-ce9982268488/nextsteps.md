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

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Connection strings in `appsettings.json` are valid and accessible from the target environment.
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test the primary user flows, such as browsing books, authentication (if applicable), and any data entry forms.

### 7. Check for Runtime Warnings

While running the application, monitor the console output for runtime warnings such as:

- Obsolete API usage
- Missing middleware registrations
- Configuration binding issues

### 8. Review `Bookstore.Web` Startup Configuration

Confirm that the application startup code follows the modern .NET pattern. If the project previously used `Startup.cs` with separate `ConfigureServices` and `Configure` methods, consider consolidating into the minimal hosting model in `Program.cs` if that aligns with your team's preferences.

### 9. Validate Static Files and Views

If the project uses Razor Views or static assets, confirm that:

- The `wwwroot` folder is present and correctly structured.
- Razor views render without runtime compilation errors.
- Any bundling or minification configurations are compatible with the new project structure.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce deployment artifacts:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify Published Output

Inspect the `./publish` directory to confirm all required files are present, including:

- The application binary and its dependencies
- `appsettings.json` and any environment-specific configuration files
- The `wwwroot` folder with static assets

### 3. Configure the Target Environment

Ensure the target server or hosting environment has the correct .NET runtime installed. You can verify the required runtime version from the `.csproj` `<TargetFramework>` value and download the corresponding runtime from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).

### 4. Update Environment-Specific Configuration

Confirm that `appsettings.Production.json` (or equivalent environment-specific files) contains the correct values for connection strings, logging levels, and any other environment-dependent settings before deploying.