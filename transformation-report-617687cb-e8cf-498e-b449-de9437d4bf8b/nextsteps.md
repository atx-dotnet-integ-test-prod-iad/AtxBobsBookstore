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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project still references `net48` or any other Windows-only framework moniker unless intentional.

### 4. Run the Application Locally

Start the web application to verify it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the displayed local URL and exercise the core functionality of the application, including any pages that interact with the data and domain layers.

### 5. Run Existing Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test
```

Review any failing tests, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the database connection string in `appsettings.json` is valid for the target environment. If migrations are present, verify they apply cleanly:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Check for Windows-Specific API Usage

Even without build errors, the code may reference APIs that only function on Windows. Use the .NET compatibility analyzer to surface these at build time by adding the following to each `.csproj` file if not already present:

```xml
<PropertyGroup>
  <EnableNETAnalyzers>true</EnableNETAnalyzers>
  <AnalysisMode>All</AnalysisMode>
</PropertyGroup>
```

Rebuild and review any new diagnostics that appear.

### 8. Test on a Non-Windows Platform

If cross-platform support is a requirement, run and test the application on Linux or macOS to confirm there are no runtime issues that were not caught at compile time.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce deployment artifacts:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify Published Output

Inspect the `./publish` directory to confirm all expected files are present, including static assets, configuration files, and the compiled assemblies.

### 3. Configure the Production Environment

Ensure the following are in place before deploying to the target server:

- A valid `appsettings.Production.json` or equivalent environment-specific configuration.
- The correct .NET runtime version is installed on the target server. You can verify the required version from the `.csproj` `<TargetFramework>` value.
- Appropriate file and network permissions are configured on the host.

### 4. Deploy to the Target Server

Copy the contents of the `./publish` directory to the target server and start the application using the appropriate hosting mechanism, such as Kestrel directly, IIS with the ASP.NET Core Module, or a reverse proxy such as Nginx.