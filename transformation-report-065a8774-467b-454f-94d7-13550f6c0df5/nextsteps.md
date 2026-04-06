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

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless intentionally required.

### 4. Check for Windows-Specific Dependencies

Review the NuGet package references in each project for any packages that only support Windows. You can inspect this by checking the `<PackageReference>` entries in each `.csproj` file and cross-referencing them on [nuget.org](https://www.nuget.org) for supported platforms.

Pay particular attention to:
- `Bookstore.Data` for any data access libraries (e.g., older Entity Framework versions, SQL client libraries)
- `Bookstore.Web` for any ASP.NET or web-related packages that may have platform restrictions

### 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new framework version.

### 6. Run the Application Locally

Start the web application locally to verify it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify core functionality such as:
- Application startup and routing
- Database connectivity via `Bookstore.Data`
- Domain logic behavior via `Bookstore.Domain`

### 7. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files to ensure:
- Connection strings are valid and updated for the target environment
- Any configuration keys that were previously in `Web.config` have been correctly migrated to `appsettings.json`
- The `Web.config` file, if still present, is not being relied upon for runtime configuration

### 8. Validate Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm:
- All required assemblies are present
- The `appsettings.json` file is included
- No unnecessary development-time files are included

### 3. Deploy to Target Environment

Copy the contents of the `./publish` directory to your target hosting environment. Ensure the target machine has the appropriate .NET runtime installed. You can verify the required runtime version from the `.csproj` `<TargetFramework>` value and download the corresponding runtime from the [official .NET download page](https://dotnet.microsoft.com/en-us/download).