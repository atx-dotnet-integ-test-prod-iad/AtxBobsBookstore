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

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build. Pay particular attention to:

- Obsolete API usage warnings
- Nullable reference type warnings
- Platform compatibility warnings (e.g., `CA1416`)

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and modern .NET.

### 4. Verify Entity Framework or Data Access Layer

Since the solution includes a `Bookstore.Data` project, verify the data access layer is functioning correctly:

- Confirm the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- If the project uses migrations, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All pages or API endpoints load as expected.
- Database reads and writes function correctly.
- Authentication and authorization behave as expected, if applicable.

### 6. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) contain all configuration values that were previously held in `Web.config` or `App.config`. Common items to verify include:

- Connection strings
- Application settings keys
- Logging configuration

### 7. Check for Removed or Changed APIs

Review any code that relied on APIs specific to .NET Framework that may have changed behavior or been removed in modern .NET. Key areas to inspect include:

- `System.Web` references (not available in modern .NET)
- `HttpContext` usage patterns
- WCF or Remoting dependencies
- `ConfigurationManager` usage (requires `System.Configuration.ConfigurationManager` NuGet package if still used)

### 8. Target Framework Confirmation

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects in the solution.

## Deployment

Once local validation is complete, proceed with the following steps before deploying to a target environment:

1. Confirm the target server or hosting environment has the correct .NET runtime installed. You can verify available runtimes with:

```bash
dotnet --list-runtimes
```

2. Publish the web application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

3. Verify the contents of the `./publish` directory and deploy them to the target environment according to your existing hosting setup (e.g., IIS, self-hosted, Azure App Service).

4. After deployment, perform a smoke test against the live environment to confirm the application is operating correctly.