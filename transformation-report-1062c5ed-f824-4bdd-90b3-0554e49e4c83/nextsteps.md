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

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues introduced during migration.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test output carefully. Any failing tests that previously passed may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Pay particular attention to the following areas, which commonly surface runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, verify that migrations are compatible with the new runtime.
- **Configuration**: Ensure that `appsettings.json` (or equivalent) contains all settings previously held in `Web.config` or `App.config`. The `System.Configuration` namespace is not fully available in cross-platform .NET.
- **Authentication and authorization**: If ASP.NET membership or Windows Authentication was used, confirm that the replacement mechanisms are functioning correctly.
- **Static files and routing**: Verify that pages, routes, and static assets resolve as expected in the new ASP.NET Core pipeline if a migration from ASP.NET MVC or Web Forms occurred.

### 5. Review Replaced or Removed APIs

Cross-reference the codebase against the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/) or run the following analyzer to catch any remaining API compatibility concerns:

```bash
dotnet add package Microsoft.DotNet.UpgradeAssistant.Extensions.Default.Analyzers
dotnet build
```

### 6. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-framework reference issues.

## Deployment

### 1. Publish the Application

Publish the web application to a folder for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all expected assemblies, configuration files, and static assets are present.

### 3. Configure the Hosting Environment

- If deploying to **IIS**, install the [.NET Hosting Bundle](https://dotnet.microsoft.com/en-us/download/dotnet) on the server and configure the application pool to use **No Managed Code**, as Kestrel handles the runtime.
- If deploying to a **Linux server**, ensure the appropriate .NET runtime version is installed and configure a reverse proxy such as Nginx or Apache if required.

### 4. Validate the Production Configuration

Confirm that environment-specific configuration (connection strings, API keys, etc.) is correctly set via environment variables or a production `appsettings.Production.json` file, and that sensitive values are not committed to source control.