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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify core logic is functioning as expected:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the domain and data layers before deploying.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations or database configurations are compatible with the new target framework. Run the following to check pending migrations:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If you are using a `DbContext`, verify the connection string in `appsettings.json` is correct for your target environment.

### 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that:
- Pages load without errors
- Database reads and writes function correctly
- Any authentication or session handling works as expected

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element references the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 7. Check for Removed or Changed APIs

Review any code that previously relied on APIs that were removed or changed between .NET Framework and modern .NET. Common areas to check include:

- `System.Web` references, which are not available in modern .NET
- `HttpContext` usage patterns
- `ConfigurationManager`, which should be replaced with `IConfiguration`
- `BinaryFormatter`, which is disabled by default in modern .NET

### 8. Publish the Application

Once local validation is complete, publish the application to your target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files, including static assets and configuration files, are present before deploying to the target server.